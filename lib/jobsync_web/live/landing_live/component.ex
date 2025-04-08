defmodule JobsyncWeb.Landing.Component do
  use Phoenix.Component

  def header(assigns) do
    ~H"""
    <div class="flex flex-col gap-5 items-center lg:items-start">
      <h6>Job Application Tracker</h6>
      <h1>JobSync</h1>
      <p class="text-base">
        The best way to track your Job Applications at Scale, designed for portability
      </p>
    </div>
    """
  end

  attr :icon, :string, required: true
  slot :upper
  slot :lower

  def elem(assigns) do
    ~H"""
    <li class="flex items-center gap-5">
      <Heroicons.icon name={@icon} class="w-6 h-6" />
      <div class="flex flex-col items-left">
        <p class="text-base font-bold"><%= render_slot(@upper) %></p>
        <p class="text-sm"><%= render_slot(@lower) %></p>
      </div>
    </li>
    """
  end
end
