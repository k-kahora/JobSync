defmodule JobsyncWeb.SurveyLive do
  use JobsyncWeb, :live_view
  alias JobsyncWeb.SurveyLive.Component
  alias JobsyncWeb.SurveyLive.Show
  alias Jobsync.Survey

  @impl true

  def mount(_params, _session, socket) do
    {:ok, socket |> assign_empty |> clear_form}
  end

  def assign_empty(socket) do
    assign(socket, :goal, %Survey.Goal{
      target_title: "Software Engineer",
      target_salary: 80000,
      target_date: ~D[2002-02-23]
    })
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
