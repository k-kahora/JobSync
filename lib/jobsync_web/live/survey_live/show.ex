defmodule JobsyncWeb.SurveyLive.Show do
  # import Phoenix.HTML
  alias JobsyncWeb.CoreComponents
  alias Jobsync.Survey.Goal
  use Phoenix.Component

  attr :goal, Goal, required: false

  def details(assigns) do
    ~H"""
    <div>
      <h2 class="font-medium text-2xl"></h2>
      <ul>
        <li>Goal Title: {@goal.target_title}</li>
        <li>Goal Date: {@goal.target_date}</li>
        <li>Target salary: {@goal.target_salary}</li>
      </ul>
    </div>
    <div>
      <CoreComponents.table rows={[@goal]} id={to_string(@goal.id)}>
        <:col let={@goal} label="Goal Title">{@goal.target_title}</:col>
        <:col let={@goal} label="Goal Date">{@goal.target_date}</:col>
        <:col let={@goal} label="Goal Salary">{@goal.target_salary}</:col>
      </CoreComponents.table>
    </div>
    """
  end
end
