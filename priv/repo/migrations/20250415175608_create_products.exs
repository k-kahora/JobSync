defmodule Jobsync.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :unit_price, :float
      add :sku, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:products, [:sku])
  end
end
