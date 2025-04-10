defmodule JobsyncWeb.HomeLive.Index do
  use JobsyncWeb, :live_view
  alias JobsyncWeb.HomeLive.Component
  # Goals
  # Career Goal grid box
  #  Job App Career Goals

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :test, "testing")}
  end

  def render(assigns) do
    ~H"""
    <div class="grid grid-cols-1 gap-4">
      <Component.goals goal="Land a job"></Component.goals>
      <Component.applications></Component.applications>
    </div>
    """
  end
end
