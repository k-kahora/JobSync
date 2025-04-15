defmodule Jobsync.ApplicationsTest do
  use Jobsync.DataCase

  alias Jobsync.Applications

  describe "jobs" do
    alias Jobsync.Applications.Jobs

    import Jobsync.ApplicationsFixtures

    @invalid_attrs %{status: nil, date: nil, description: nil, title: nil, company: nil, notes: nil}

    test "list_jobs/0 returns all jobs" do
      jobs = jobs_fixture()
      assert Applications.list_jobs() == [jobs]
    end

    test "get_jobs!/1 returns the jobs with given id" do
      jobs = jobs_fixture()
      assert Applications.get_jobs!(jobs.id) == jobs
    end

    test "create_jobs/1 with valid data creates a jobs" do
      valid_attrs = %{status: :applied, date: ~D[2025-04-13], description: "some description", title: "some title", company: "some company", notes: "some notes"}

      assert {:ok, %Jobs{} = jobs} = Applications.create_jobs(valid_attrs)
      assert jobs.status == :applied
      assert jobs.date == ~D[2025-04-13]
      assert jobs.description == "some description"
      assert jobs.title == "some title"
      assert jobs.company == "some company"
      assert jobs.notes == "some notes"
    end

    test "create_jobs/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Applications.create_jobs(@invalid_attrs)
    end

    test "update_jobs/2 with valid data updates the jobs" do
      jobs = jobs_fixture()
      update_attrs = %{status: :ghosted, date: ~D[2025-04-14], description: "some updated description", title: "some updated title", company: "some updated company", notes: "some updated notes"}

      assert {:ok, %Jobs{} = jobs} = Applications.update_jobs(jobs, update_attrs)
      assert jobs.status == :ghosted
      assert jobs.date == ~D[2025-04-14]
      assert jobs.description == "some updated description"
      assert jobs.title == "some updated title"
      assert jobs.company == "some updated company"
      assert jobs.notes == "some updated notes"
    end

    test "update_jobs/2 with invalid data returns error changeset" do
      jobs = jobs_fixture()
      assert {:error, %Ecto.Changeset{}} = Applications.update_jobs(jobs, @invalid_attrs)
      assert jobs == Applications.get_jobs!(jobs.id)
    end

    test "delete_jobs/1 deletes the jobs" do
      jobs = jobs_fixture()
      assert {:ok, %Jobs{}} = Applications.delete_jobs(jobs)
      assert_raise Ecto.NoResultsError, fn -> Applications.get_jobs!(jobs.id) end
    end

    test "change_jobs/1 returns a jobs changeset" do
      jobs = jobs_fixture()
      assert %Ecto.Changeset{} = Applications.change_jobs(jobs)
    end
  end
end
