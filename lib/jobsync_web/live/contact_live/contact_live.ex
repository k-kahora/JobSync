defmodule JobsyncWeb.ContactLive do
  use JobsyncWeb, :live_view
  alias Jobsync.Contact
  alias Jobsync.Contact.Recipient

  def mount(_params, session, socket) do
    {:ok, socket |> assign_recipient |> clear_form}
  end

  # only runs on mount
  def assign_recipient(socket) do
    assign(socket, :recipient, %Recipient{})
  end

  # only runs on mount
  def clear_form(socket) do
    form =
      socket.assigns.recipient
      |> Contact.change_recipient()
      |> to_form()

    assign(socket, :form, form)
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end

  def handle_event("save", %{"recipient" => recipient_params}, socket) do
    inspect(recipient_params) |> IO.puts()
    :timer.sleep(1000)
  end

  def handle_event(
        "validate",
        %{"recipient" => recipient_params},
        %{assigns: %{recipient: recipient}} = socket
      ) do
    changeset =
      recipient |> Contact.change_recipient(recipient_params) |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def assign_form(socket, changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
