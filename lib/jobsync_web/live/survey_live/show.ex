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

  def show_key(nil) do
    ""
  end

  def show_key(path) do
    Path.basename(path) |> String.split("-") |> List.last()
  end

  def handle_event("download", %{"resume_key" => s3_key}, socket) do
    {:ok, %{body: body}} = ExAws.S3.get_object("jobsync-filestore-sql", s3_key) |> ExAws.request()
    # IO.puts(inspect(object, pretty: true))
    {:ok, url} =
      ExAws.Config.new(:s3)
      |> ExAws.S3.presigned_url(:get, "jobsync-filestore-sql", s3_key, expires_in: 10)

    IO.puts(url)

    # {:noreply, socket}
    {:noreply, push_event(socket, "open_new_tab", %{url: url})}
  end
end
