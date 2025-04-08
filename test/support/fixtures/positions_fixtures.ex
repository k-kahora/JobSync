defmodule Jobsync.PositionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jobsync.Positions` context.
  """

  @doc """
  Generate a job.
  """
  def job_fixture(attrs \\ %{}) do
    {:ok, job} =
      attrs
      |> Enum.into(%{
        company: "some company",
        date_applied: ~D[2025-04-07],
        description: "some description",
        notes: "some notes",
        state: "some state",
        title: "some title"
      })
      |> Jobsync.Positions.create_job()

    job
  end
end
