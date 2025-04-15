defmodule Jobsync.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs) do
      add :description, :string
      add :date, :date
      add :company, :string
      add :title, :string
      add :notes, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end
  end
end
