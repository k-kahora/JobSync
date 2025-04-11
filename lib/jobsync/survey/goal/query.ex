defmodule Jobsync.Survey.Goal.Query do
  import Ecto.Query
  alias Jobsync.Survey.Goal

  def base do
    Goal
  end

  def for_user(query \\ base(), user) do
    query |> where([d], d.user_id == ^user.id)
  end
end
