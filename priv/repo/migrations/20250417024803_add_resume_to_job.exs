defmodule Jobsync.Repo.Migrations.AddResumeToJob do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :resume_key, :string
    end
  end
end
