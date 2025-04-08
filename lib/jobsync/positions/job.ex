defmodule Jobsync.Positions.Job do
  use Ecto.Schema
  import Ecto.Changeset

  schema "jobs" do
    field :state, :string
    field :description, :string
    field :title, :string
    field :date_applied, :date
    field :company, :string
    field :notes, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:description, :state, :date_applied, :company, :title, :notes])
    |> validate_required([:description, :state, :date_applied, :company, :title, :notes])
  end
end
