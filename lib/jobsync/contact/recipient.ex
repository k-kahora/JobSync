defmodule Jobsync.Contact.Recipient do
  use Ecto.Schema
  import Ecto.Changeset
  @primary_key false

  embedded_schema do
    field :first_name, :string
    field :email, :string
    field :phone_number, :string
    field :message, :string
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :email, :phone_number, :message])
    |> validate_required([:first_name, :email, :phone_number, :message])
    |> validate_format(:email, ~r/@/)
    |> validate_format(:phone_number, ~r/^\d{3}-\d{3}-\d{4}$/)
  end
end
