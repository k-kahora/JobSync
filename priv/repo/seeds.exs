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

import Ecto.Query
alias Jobsync.Accounts.User
alias Jobsync.Applications.Jobs
alias Jobsync.{Repo, Accounts, Applications}

for i <- 1..10 do
  Accounts.register_user(%{email: "user#{i}@gmail.com", password: "userpassword#{i}"})
end

user_ids = Repo.all(from u in User, select: u.id)
# TODO Randomize the inputs

jobs = [
  %{
    status: :applied,
    date: ~D[2025-02-23],
    title: "Software Engineer Specialist",
    company: "Apple",
    description: "Work as a SWE",
    notes: "Wating to hear back have not reached out"
  },
  %{
    status: :applied,
    date: ~D[2024-11-23],
    title: "Data Analysyt",
    company: "Johnson & Johnson",
    description: "Work as a buisness guru",
    notes: "User a frat kid a refferal"
  },
  %{
    status: :ghosted,
    date: ~D[2025-02-23],
    title: "TDP",
    company: "AT&T",
    description: "Entry Level Job",
    notes: "Applied 30 days ago, ghosted after interview"
  }
]

for uuid <- user_ids do
  for job <- jobs do
    Applications.create_jobs(Map.put(job, :user_id, uuid))
  end
end
