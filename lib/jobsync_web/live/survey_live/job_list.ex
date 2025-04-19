defmodule JobsyncWeb.SurveyLive.JobList do
  use JobsyncWeb, :live_component
  alias Jobsync.Applications
  alias Jobsync.Applications.Jobs
  alias JobsyncWeb.Components.Widgets.Base

  def update(assigns, socket) do
    socket = socket |> assign(assigns) |> assign(:jobs, "No jobs") |> assign_jobs()
    # {:ok, socket |> assign(assigns) |> assign(:jobs, "No jobs") |> assign_jobs()}
    IO.puts(assigns |> inspect(pretty: true))
    {:ok, socket}
  end

  defp assign_jobs(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :jobs, Applications.get_jobs_by_user(current_user))
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end
end
