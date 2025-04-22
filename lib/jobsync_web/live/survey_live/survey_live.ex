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
      |> stream(:jobs, Applications.get_jobs_by_user(socket.assigns.current_user))

    {:ok, socket}

    # |> clear_form}
  end

  @impl true
  def handle_params(params, _uri, %{assigns: assigns} = socket) do
    socket =
      socket
      |> apply_action(assigns.live_action, params)

    # |> apply_jobs()

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
    |> assign(:job, %Applications.Jobs{
      user_id: socket.assigns.current_user.id,
      date: ~D[2025-08-24],
      title: "Test Engineer",
      company: "Ramp",
      status: :applied
    })

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
    IO.inspect(socket.assigns[:current_user], label: "CURRENT USER AT MOUNT")
    {:noreply, stream_insert(socket, :jobs, job)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    job = Applications.get_jobs!(id)
    {:ok, _} = Applications.delete_jobs(job)
    {:noreply, stream_delete(socket, :jobs, job)}
  end

  def handle_event("validate-upload", params, socket) do
    {:noreply, socket}
  end
end
