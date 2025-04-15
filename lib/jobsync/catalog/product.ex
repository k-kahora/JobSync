defmodule Jobsync.Catalog.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :name, :string
    field :unit_price, :float
    field :sku, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :unit_price, :sku])
    |> validate_required([:name, :unit_price, :sku])
    |> unique_constraint(:sku)
  end
end
