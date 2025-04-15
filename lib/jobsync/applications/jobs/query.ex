defmodule Jobsync.Applications.Jobs.Query do
  import Ecto.Query
  alias Jobsync.Applications.Jobs
  def base, do: Jobs

  def user_jobs(query \\ base(), user) do
    query |> where([d], d.user_id == ^user.id)
  end
end
