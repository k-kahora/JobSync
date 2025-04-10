defmodule JobsyncWeb.HomeLive.Component do
  use Phoenix.Component

  attr :goal, :string, required: true

  def applications(assigns) do
    ~H"""
    <div class="flex flex-col bg-gray-100 px-10 py-8 gap-y-10">
      <p>Job Applications</p>
      <p>Apps Sents</p>
      <p>Goal</p>
    </div>
    """
  end

  def goals(assigns) do
    ~H"""
    <div class="flex flex-col items-left bg-gray-100 px-10 py-8 gap-y-10 ">
      <h6><span>Career Goal: </span>{@goal}</h6>
      <p>Target Title</p>
      <p>Target Date</p>
      <p>Target Salary Range</p>
    </div>
    """
  end
end
