defmodule Jobsync.Survey.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  schema "goals" do
    field :target_title, :string
    field :target_date, :date
    field :target_salary, :integer
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:target_title, :target_date, :target_salary, :user_id])
    |> validate_required([:target_title, :target_date, :target_salary, :user_id])
    |> unique_constraint(:user_id)
  end
end
