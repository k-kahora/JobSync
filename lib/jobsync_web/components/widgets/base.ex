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

  slot :action, doc: "slot for showing user actions in last column"

  attr :row_click, :any, default: nil, doc: "func for clicking the row"

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
        <tr
          :for={row <- @rows}
          phx-click={@row_click && @row_click.(row)}
          class={["p-0", @row_click && "hover:cursor-pointer"]}
        >
          <td :for={{col, i} <- Enum.with_index(@col)}>
            {render_slot(col, @row_item.(row))}
          </td>
          <td :for={action <- @action}>
            <span>
              {render_slot(action, @row_item.(row))}
            </span>
          </td>
        </tr>
      </tbody>
    </table>
    """
  end

  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div>
      <dl>
        <div :for={item <- @item}>
          <dl>{item.title}</dl>
          <dt>render_slot(item)</dt>
        </div>
      </dl>
    </div>
    """
  end

  attr :form, :any, required: true
  attr :as, :any, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  slot :actions

  def simple_form(assigns) do
    ~H"""
    <.form for={@form} {@rest}>
      {render_slot(@inner_block)}
      <div :for={action <- @actions}>
        {render_slot(action)}
      </div>
    </.form>
    """
  end

  attr :type, :string, default: "text", values: ~w(text)

  attr :field, Phoenix.HTML.FormField

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns =
      assigns
      |> assign(field: nil)
      |> assign(id: field.id)
      |> assign(name: field.name)
      |> assign_new(:value, fn -> field.value end)

    input(assigns)
  end

  def input(%{type: "date"} = assigns) do
    ~H"""
    <input name={@name} id="thing-date" value={@value} type="date" />
    """
  end

  def input(%{type: "text"} = assigns) do
    ~H"""
    <input name={@name} id="thing" value={@value} type="text" />
    """
  end
end
