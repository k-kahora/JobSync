defmodule Jobsync.PositionsTest do
  use Jobsync.DataCase

  alias Jobsync.Positions

  describe "jobs" do
    alias Jobsync.Positions.Job

    import Jobsync.PositionsFixtures

    @invalid_attrs %{state: nil, description: nil, title: nil, date_applied: nil, company: nil, notes: nil}

    test "list_jobs/0 returns all jobs" do
      job = job_fixture()
      assert Positions.list_jobs() == [job]
    end

    test "get_job!/1 returns the job with given id" do
      job = job_fixture()
      assert Positions.get_job!(job.id) == job
    end

    test "create_job/1 with valid data creates a job" do
      valid_attrs = %{state: "some state", description: "some description", title: "some title", date_applied: ~D[2025-04-07], company: "some company", notes: "some notes"}

      assert {:ok, %Job{} = job} = Positions.create_job(valid_attrs)
      assert job.state == "some state"
      assert job.description == "some description"
      assert job.title == "some title"
      assert job.date_applied == ~D[2025-04-07]
      assert job.company == "some company"
      assert job.notes == "some notes"
    end

    test "create_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Positions.create_job(@invalid_attrs)
    end

    test "update_job/2 with valid data updates the job" do
      job = job_fixture()
      update_attrs = %{state: "some updated state", description: "some updated description", title: "some updated title", date_applied: ~D[2025-04-08], company: "some updated company", notes: "some updated notes"}

      assert {:ok, %Job{} = job} = Positions.update_job(job, update_attrs)
      assert job.state == "some updated state"
      assert job.description == "some updated description"
      assert job.title == "some updated title"
      assert job.date_applied == ~D[2025-04-08]
      assert job.company == "some updated company"
      assert job.notes == "some updated notes"
    end

    test "update_job/2 with invalid data returns error changeset" do
      job = job_fixture()
      assert {:error, %Ecto.Changeset{}} = Positions.update_job(job, @invalid_attrs)
      assert job == Positions.get_job!(job.id)
    end

    test "delete_job/1 deletes the job" do
      job = job_fixture()
      assert {:ok, %Job{}} = Positions.delete_job(job)
      assert_raise Ecto.NoResultsError, fn -> Positions.get_job!(job.id) end
    end

    test "change_job/1 returns a job changeset" do
      job = job_fixture()
      assert %Ecto.Changeset{} = Positions.change_job(job)
    end
  end
end
