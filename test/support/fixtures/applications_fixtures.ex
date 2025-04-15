defmodule Jobsync.ApplicationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jobsync.Applications` context.
  """

  @doc """
  Generate a jobs.
  """
  def jobs_fixture(attrs \\ %{}) do
    {:ok, jobs} =
      attrs
      |> Enum.into(%{
        company: "some company",
        date: ~D[2025-04-13],
        description: "some description",
        notes: "some notes",
        status: :applied,
        title: "some title"
      })
      |> Jobsync.Applications.create_jobs()

    jobs
  end
end
