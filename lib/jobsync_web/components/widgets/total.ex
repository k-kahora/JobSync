defmodule JobsyncWeb.Components.Widgets.Base do
  use Phoenix.Component
  attr :number, :integer
  attr :heading, :string
  attr :previous, :integer
  attr :footer, :string
  attr :unit, :string

  def total(assigns) do
    ~H"""
    <div class="flex flex-col">
      <h3>{@heading}</h3>
      <h1 class="text-5xl"><span class={@unit}></span> {@number}</h1>
      <p>{percent(@number, @previous)} {@footer}</p>
    </div>
    """
  end

  def percent(start, prev) do
    if start == 0 do
      "N/A"
    else
      change = (start - prev) / prev * 100
      sign = if change >= 0, do: "+", else: "-"
      formatted = Float.round(abs(change), 2)
      "#{sign}#{formatted}%"
    end
  end
end
