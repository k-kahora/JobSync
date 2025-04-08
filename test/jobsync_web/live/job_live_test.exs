defmodule JobsyncWeb.JobLiveTest do
  use JobsyncWeb.ConnCase

  import Phoenix.LiveViewTest
  import Jobsync.PositionsFixtures

  @create_attrs %{state: "some state", description: "some description", title: "some title", date_applied: "2025-04-07", company: "some company", notes: "some notes"}
  @update_attrs %{state: "some updated state", description: "some updated description", title: "some updated title", date_applied: "2025-04-08", company: "some updated company", notes: "some updated notes"}
  @invalid_attrs %{state: nil, description: nil, title: nil, date_applied: nil, company: nil, notes: nil}

  defp create_job(_) do
    job = job_fixture()
    %{job: job}
  end

  describe "Index" do
    setup [:create_job]

    test "lists all jobs", %{conn: conn, job: job} do
      {:ok, _index_live, html} = live(conn, ~p"/jobs")

      assert html =~ "Listing Jobs"
      assert html =~ job.state
    end

    test "saves new job", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/jobs")

      assert index_live |> element("a", "New Job") |> render_click() =~
               "New Job"

      assert_patch(index_live, ~p"/jobs/new")

      assert index_live
             |> form("#job-form", job: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#job-form", job: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/jobs")

      html = render(index_live)
      assert html =~ "Job created successfully"
      assert html =~ "some state"
    end

    test "updates job in listing", %{conn: conn, job: job} do
      {:ok, index_live, _html} = live(conn, ~p"/jobs")

      assert index_live |> element("#jobs-#{job.id} a", "Edit") |> render_click() =~
               "Edit Job"

      assert_patch(index_live, ~p"/jobs/#{job}/edit")

      assert index_live
             |> form("#job-form", job: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#job-form", job: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/jobs")

      html = render(index_live)
      assert html =~ "Job updated successfully"
      assert html =~ "some updated state"
    end

    test "deletes job in listing", %{conn: conn, job: job} do
      {:ok, index_live, _html} = live(conn, ~p"/jobs")

      assert index_live |> element("#jobs-#{job.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#jobs-#{job.id}")
    end
  end

  describe "Show" do
    setup [:create_job]

    test "displays job", %{conn: conn, job: job} do
      {:ok, _show_live, html} = live(conn, ~p"/jobs/#{job}")

      assert html =~ "Show Job"
      assert html =~ job.state
    end

    test "updates job within modal", %{conn: conn, job: job} do
      {:ok, show_live, _html} = live(conn, ~p"/jobs/#{job}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Job"

      assert_patch(show_live, ~p"/jobs/#{job}/show/edit")

      assert show_live
             |> form("#job-form", job: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#job-form", job: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/jobs/#{job}")

      html = render(show_live)
      assert html =~ "Job updated successfully"
      assert html =~ "some updated state"
    end
  end
end
