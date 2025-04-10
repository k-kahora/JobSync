defmodule Jobsync.SurveyTest do
  use Jobsync.DataCase

  alias Jobsync.Survey

  describe "goals" do
    alias Jobsync.Survey.Goal

    import Jobsync.SurveyFixtures

    @invalid_attrs %{target_title: nil, target_date: nil, target_salary: nil}

    test "list_goals/0 returns all goals" do
      goal = goal_fixture()
      assert Survey.list_goals() == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      goal = goal_fixture()
      assert Survey.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      valid_attrs = %{target_title: "some target_title", target_date: ~D[2025-04-09], target_salary: 42}

      assert {:ok, %Goal{} = goal} = Survey.create_goal(valid_attrs)
      assert goal.target_title == "some target_title"
      assert goal.target_date == ~D[2025-04-09]
      assert goal.target_salary == 42
    end

    test "create_goal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Survey.create_goal(@invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      goal = goal_fixture()
      update_attrs = %{target_title: "some updated target_title", target_date: ~D[2025-04-10], target_salary: 43}

      assert {:ok, %Goal{} = goal} = Survey.update_goal(goal, update_attrs)
      assert goal.target_title == "some updated target_title"
      assert goal.target_date == ~D[2025-04-10]
      assert goal.target_salary == 43
    end

    test "update_goal/2 with invalid data returns error changeset" do
      goal = goal_fixture()
      assert {:error, %Ecto.Changeset{}} = Survey.update_goal(goal, @invalid_attrs)
      assert goal == Survey.get_goal!(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{}} = Survey.delete_goal(goal)
      assert_raise Ecto.NoResultsError, fn -> Survey.get_goal!(goal.id) end
    end

    test "change_goal/1 returns a goal changeset" do
      goal = goal_fixture()
      assert %Ecto.Changeset{} = Survey.change_goal(goal)
    end
  end
end
