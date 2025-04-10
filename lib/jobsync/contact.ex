defmodule Jobsync.Contact do
  alias Jobsync.Contact.Recipient

  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end

  def send_message() do
    # send email to admin account to adress the issue
    {:ok, %Recipient{}}
  end
end
