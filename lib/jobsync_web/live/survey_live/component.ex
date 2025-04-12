defmodule JobsyncWeb.SurveyLive.Component do
  use Phoenix.Component
  attr :content, :string, required: true
  slot :inner_block, required: true
  use Phoenix.Component

  def hero(assigns) do
    ~H"""
    <h1 class="font-heay text-3xl">
      Survey
    </h1>
    <h3>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  @doc ~S"""
  Renders a simple card based form
  """

  attr :form, :any, required: false

  def card(assigns) do
    ~H"""
    <.form for={@form} phx-submit="save_user">
      <.input field={@form[:target_title]} label="target title" />
      <.input field={@form[:target_date]} label="target date" type="date" />
      <.input field={@form[:target_salary]} label="target salary" type="integer" />
    </.form>
    """
  end

  attr :field, Phoenix.HTML.FormField
  attr :label, String
  attr :type, :string, default: "text", values: ~w(text date integer)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns |> assign(field: nil) |> assign_new(:value, fn -> field.value end) |> input()
  end

  def input(%{type: "text"} = assigns) do
    ~H"""
    <label>{@label}</label>
    <input type="text" value={@value} />
    """
  end

  def input(%{type: "integer"} = assigns) do
    ~H"""
    <label>{@label}</label>
    <input type="integer" value={@value} />
    """
  end

  def input(%{type: "date"} = assigns) do
    ~H"""
    <label>{@label}</label>
    <input type="date" value={@value} />
    """
  end
end
