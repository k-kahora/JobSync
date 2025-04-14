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

  attr :form, :any, required: true

  def simple_form(assigns) do
    ~H"""
    <.form
      for={@form}
      phx-submit="save_goal"
      phx-change="validate"
      class="flex flex-col items-center p-10 gap-1"
    >
      <.input field={@form[:target_title]} label="target title" />
      <.input field={@form[:target_date]} label="target date" type="date" />
      <.input field={@form[:target_salary]} label="target salary" type="integer" />
      <%!-- <button>Save</button> --%>
      <%!-- <.form_button class="bg-stone-950 text-white">Submit</.form_button> --%>
      <section class="flex justify-between w-full mt-3">
        <.form_button class="bg-stone-950 text-white">Submit</.form_button>
      </section>
    </.form>
    """
  end

  slot :inner_block, required: true
  attr :class, :string, default: nil

  def form_button(assigns) do
    ~H"""
    <button class={["font-mono rounded-md p-1", @class]}>{render_slot(@inner_block)}</button>
    """
  end

  attr :form, :any, required: false

  def card(assigns) do
    ~H"""
    <div class="flex flex-col">
      <.simple_form form={@form}></.simple_form>
    </div>
    """
  end


  def render_detail({message, values}) do
    Enum.reduce(values, message, fn {k, v}, acc ->
      String.replace(acc, "%{#{k}}", to_string(v))
    end)
  end

  def render_detail(message) do
    message
  end

  attr :field, Phoenix.HTML.FormField
  attr :label, String
  attr :type, :string, default: "text", values: ~w(text date integer)

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = if Phoenix.Component.used_input?(field), do: field.errors, else: []
    errors = Enum.map(errors, &translate_error(&1))
    IO.puts(inspect(errors, pretty: true))

    assigns
    |> assign(field: nil)
    |> assign(:errors, errors)
    |> assign(id: field.id)
    |> assign(name: field.name)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "text"} = assigns) do
    ~H"""
    <div class="flex flex-col">
      <.label for={@label}>{@label}</.label>
      <input
        name={@name}
        id={@id}
        type="text"
        value={@value}
        class="rounded-md shadow-md w-full font-mono"
      />
    </div>
    <.error :for={msg <- @errors}>{msg}</.error>
    """
  end

  def input(%{type: "integer"} = assigns) do
    ~H"""
    <div class="flex flex-col">
      <.label for={@label}>{@label}</.label>
      <input
        name={@name}
        id={@id}
        type="number"
        value={@value}
        class={[
          "rounded-md shadow-md w-full font-mono",
          @errors != [] && "border-red-700",
          @errors == [] && "border-zinc-300"
        ]}
      />
    </div>
    <.error :for={msg <- @errors}>{msg}</.error>
    """
  end

  def input(%{type: "date"} = assigns) do
    ~H"""
    <div class="flex flex-col w-full">
      <.label for={@label}>{@label}</.label>
      <input
        name={@name}
        id={@id}
        type="date"
        value={@value}
        class="rounded-md shadow-md w-full font-mono"
      />
    </div>
    <.error :for={msg <- @errors}>{msg}</.error>
    """
  end

  attr :for, :string, default: nil
  slot :inner_block, required: true

  def label(assigns) do
    ~H"""
    <label for={@for} class="text-zinc-800 font-mono">
      {render_slot(@inner_block)}
    </label>
    """
  end

  slot :inner_block, required: true

  def error(assigns) do
    ~H"""
    <p class="flex flex-gap-3 text-sm font-mono text-red-700">
      <.icon name="hero-exclamation-triangle" class="h-5 w-5 text-red-700 flex-none" />
      {render_slot(@inner_block)}
    </p>
    """
  end

  attr :class, :string, default: nil
  attr :name, :string, required: true

  def icon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # However the error messages in our forms and APIs are generated
    # dynamically, so we need to translate them by calling Gettext
    # with our gettext backend as first argument. Translations are
    # available in the errors.po file (as we use the "errors" domain).
    if count = opts[:count] do
      Gettext.dngettext(JobsyncWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(JobsyncWeb.Gettext, "errors", msg, opts)
    end
  end

  @doc """
  Translates the errors for a field from a keyword list of errors.
  """
  def translate_errors(errors, field) when is_list(errors) do
    for {^field, {msg, opts}} <- errors, do: translate_error({msg, opts})
  end
end
