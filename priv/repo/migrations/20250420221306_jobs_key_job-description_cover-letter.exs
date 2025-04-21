defmodule :"Elixir.Jobsync.Repo.Migrations.JobsKeyJob-descriptionCover-letter" do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :job_description, :string
      add :cover_letter, :string
    end
  end
end
