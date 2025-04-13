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
    |> validate_inclusion(:target_salary, 50000..300_000)
    |> validate_future_date(:target_date)
    |> validate_length(:target_title, min: 5, max: 100)
    |> unique_constraint(:user_id)
  end

  def validate_future_date(changeset, field) do
    case get_field(changeset, field) do
      nil ->
        changeset

      date ->
        if Date.compare(date, Date.utc_today()) == :gt do
          changeset
        else
          add_error(changeset, field, "date should be in future")
        end
    end
  end
end
