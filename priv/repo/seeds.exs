# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jobsync.Repo.insert!(%Jobsync.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Jobsync.Positions

jobs = [
  %{
    state: "applied",
    description: "Who cares",
    title: "software engineer",
    date_applied: ~D[2022-01-01],
    company: "amazon",
    notes: "none"
  },
  %{
    state: "applied",
    description: "Who cares",
    title: "software engineer",
    date_applied: ~D[2022-01-01],
    company: "walmart",
    notes: "none"
  },
  %{
    state: "applied",
    description: "Who cares",
    title: "software engineer",
    date_applied: ~D[2022-01-01],
    company: "apple",
    notes: "none"
  }
]

Enum.each(jobs, fn job -> Positions.create_job(job) end)
