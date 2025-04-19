defmodule JobsyncWeb.SurveyLive.Show do
  use JobsyncWeb, :live_view

  alias Jobsync.Applications
  alias JobsyncWeb.Components.Widgets.Base

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:job, Applications.get_jobs!(id))}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"

  def handle_event("save", _params, socket) do
    {:noreply, socket}
  end
end
