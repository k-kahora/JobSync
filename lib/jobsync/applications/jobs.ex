defmodule Jobsync.Applications.Jobs do
  use Ecto.Schema
  import Ecto.Changeset
  alias Jobsync.Accounts.User

  schema "jobs" do
    field :status, Ecto.Enum, values: [:applied, :ghosted, :rejected, :interviewing]
    field :date, :date
    field :description, :string
    field :title, :string
    field :company, :string
    field :notes, :string
    field :resume_key, :string
    field :cover_letter, :string
    field :job_description, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(jobs, attrs) do
    jobs
    |> cast(attrs, [
      :description,
      :date,
      :company,
      :title,
      :notes,
      :status,
      :user_id,
      :resume_key,
      :job_description,
      :cover_letter
    ])
    |> validate_required([:date, :company, :title, :status, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
