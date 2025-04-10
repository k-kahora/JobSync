defmodule Jobsync.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :target_title, :string
      add :target_date, :date
      add :target_salary, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:goals, [:user_id])
  end
end
