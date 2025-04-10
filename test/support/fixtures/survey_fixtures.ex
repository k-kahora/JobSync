defmodule Jobsync.SurveyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jobsync.Survey` context.
  """

  @doc """
  Generate a goal.
  """
  def goal_fixture(attrs \\ %{}) do
    {:ok, goal} =
      attrs
      |> Enum.into(%{
        target_date: ~D[2025-04-09],
        target_salary: 42,
        target_title: "some target_title"
      })
      |> Jobsync.Survey.create_goal()

    goal
  end
end
