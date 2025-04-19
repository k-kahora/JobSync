defmodule JobsyncWeb.SurveyLive do
  use JobsyncWeb, :live_view
  alias JobsyncWeb.SurveyLive.Component
  alias JobsyncWeb.SurveyLive.Show
  alias Jobsync.Applications
  alias Jobsync.Survey
  alias JobsyncWeb.Components.Widgets.Base
  # TODO
  #   -> allow the user to attacth a s3 file key to a job struct
  #     -> organize this setup so that its no so cary ritarde
  #       -> basically puth all of this into the live component not into survey_live here

  @impl true

  def mount(_params, _session, socket) do
    socket =
      socket
      |> allow_upload(:document, accept: ~w(.pdf .md), max_entries: 1, auto_upload: true)
      |> assign_jobs()

    {:ok, socket}

    # |> clear_form}
  end

  defp assign_jobs(%{assigns: %{current_user: current_user}} = socket) do
    stream(socket, :jobs, Applications.get_jobs_by_user(current_user))
  end

  defp upload_s3(path, entry, user) do
    key = "uploads/#{user.id}/#{entry.client_name}"

    ExAws.S3.Upload.stream_file(path)
    |> ExAws.S3.upload("jobsync-filestore", key)
    |> ExAws.request()

    {:ok, key}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket = socket |> assign_jobs() |> apply_action(socket.assigns.live_action, params)

    # IO.puts(socket |> inspect(pretty: true))
    {:noreply, socket}
  end

  # def apply_action(socket, :edit, %{"id" => id} = params) do
  #   IO.puts("id -> #{params |> inspect}")
  #
  #   socket
  #   |> assign(:page_title, "edit Job")
  #   |> assign(:job, Applications.get_jobs!(id |> String.to_integer()))
  # end

  def apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "new Job")
    |> assign(:job, %Applications.Jobs{user_id: socket.assigns.current_user.id})

    # |> assign(:job, Applications.get_jobs!(id |> String.to_integer()))
  end

  def apply_action(socket, :edit, %{"id" => id} = params) do
    IO.puts("id -> #{params |> inspect}")

    socket
    |> assign(:page_title, "edit Job")
    |> assign(:job, Applications.get_jobs!(id |> String.to_integer()))
  end

  def apply_action(socket, :show, %{"id" => id} = params) do
    IO.puts("id -> #{params |> inspect}")

    socket
    |> assign(:page_title, "Show Job")
    |> assign(:job, Applications.get_jobs!(id |> String.to_integer()))
  end

  def apply_action(socket, _, params) do
    socket
  end

  def handle_info({JobsyncWeb.SurveyLive.FormComponent, {:saved, job}}, socket) do
    {:noreply, assign_jobs(socket)}
  end
end
