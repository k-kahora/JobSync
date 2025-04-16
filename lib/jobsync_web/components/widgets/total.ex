defmodule JobsyncWeb.Components.Widgets.Base do
  use Phoenix.Component

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

  attr :id, :string, required: true
  attr :rows, :list, required: true

  slot :col, required: true do
    attr :label, :string
  end

  attr :row_item, :any,
    default: &Function.identity/1,
    doc:
      "this function maps each row before calling :col and :action slots so you can pass it in with :let"

  def table(assigns) do
    ~H"""
    <table>
      <thead>
        <tr>
          <th :for={col <- @col}>{col[:label]}</th>
        </tr>
      </thead>
      <tbody>
        <tr :for={row <- @rows}>
          <td :for={{col, i} <- Enum.with_index(@col)}>
            {render_slot(col, @row_item.(row))}
          </td>
        </tr>
      </tbody>
    </table>
    """
  end
end
