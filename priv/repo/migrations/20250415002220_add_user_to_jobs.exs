defmodule Jobsync.Repo.Migrations.AddUserToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:jobs, [:user_id])
  end
end
