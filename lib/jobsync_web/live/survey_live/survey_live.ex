defmodule JobsyncWeb.SurveyLive do
  use JobsyncWeb, :live_view
  alias JobsyncWeb.SurveyLive.Component
  alias JobsyncWeb.SurveyLive.Show
  alias Jobsync.Survey

  @impl true

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_goal}
  end

  def assign_goal(%{assigns: %{current_user: current_user}} = socket) do
    assign(socket, :goal, Survey.get_goal_by_user(current_user))
  end
end
