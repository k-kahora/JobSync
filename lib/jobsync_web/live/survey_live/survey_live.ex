defmodule JobsyncWeb.SurveyLive do
  use JobsyncWeb, :live_view
  alias JobsyncWeb.SurveyLive.Component
  alias JobsyncWeb.SurveyLive.Show
  alias Jobsync.Survey
  alias JobsyncWeb.Components.Widgets

  @impl true

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign_empty
      |> clear_form
      |> allow_upload(:document, accept: ~w(.pdf .md), max_entries: 1, auto_upload: true)

    {:ok, socket}

    # |> clear_form}
  end

  def assign_empty(%{assigns: %{current_user: user}} = socket) do
    assign(socket, :goal, Survey.get_goal_by_user(user) || %Survey.Goal{})
  end

  defp upload_s3(path, entry, user) do
    key = "uploads/#{user.id}/#{entry.client_name}"

    ExAws.S3.Upload.stream_file(path)
    |> ExAws.S3.upload("jobsync-filestore", key)
    |> ExAws.request()

    {:ok, key}
  end

  def handle_event("submit-file", params, %{assigns: %{current_user: user}} = socket) do
    image_params =
      socket
      |> consume_uploaded_entries(:document, fn %{path: path}, entry ->
        upload_s3(path, entry, user)
      end)

    socket = socket |> assign(:resume_uploads, image_params)
    IO.puts(socket |> inspect(pretty: true))

    {:noreply, socket}
  end

  def handle_event(
        "save_goal",
        %{"goal" => goal_params},
        %{assigns: %{current_user: user, goal: cur_goal}} = socket
      ) do
    case save_goal(user, cur_goal, goal_params) do
      {:ok, goal} ->
        {:noreply,
         socket
         |> assign(:goal, goal)
         |> assign_form(Survey.change_goal(goal))
         |> put_flash(:info, "Succesfuly Uploaded")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset) |> put_flash(:error, "Failed to upload")}
    end
  end

  def save_goal(user, %Survey.Goal{id: nil}, params) do
    Survey.save_goal(user, params)
  end

  def save_goal(_user, goal, params) do
    goal |> Survey.update_goal(params)
  end

  def handle_event("validate-live", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", %{"goal" => goal_params}, %{assigns: %{goal: goal}} = socket) do
    changeset = goal |> Survey.change_goal(goal_params) |> Map.put(:action, :validate)
    {:noreply, socket |> assign_form(changeset)}
  end

  def assign_goal(%{assigns: %{current_user: current_user}} = socket) do
    socket |> assign(:goal, Survey.get_goal_by_user(current_user)) |> clear_form()
  end

  def clear_form(%{assigns: %{goal: goal}} = socket) do
    form = goal |> Survey.change_goal() |> to_form()
    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
