defmodule Jobsync.Applications do
  @moduledoc """
  The Applications context.
  """

  import Ecto.Query, warn: false
  alias Jobsync.Repo

  alias Jobsync.Applications.Jobs

  @doc """
  Returns the list of jobs.

  ## Examples

      iex> list_jobs()
      [%Jobs{}, ...]

  """
  def list_jobs do
    Repo.all(Jobs)
  end

  @doc """
  Gets a single jobs.

  Raises `Ecto.NoResultsError` if the Jobs does not exist.

  ## Examples

      iex> get_jobs!(123)
      %Jobs{}

      iex> get_jobs!(456)
      ** (Ecto.NoResultsError)

  """
  def get_jobs!(id), do: Repo.get!(Jobs, id)

  @doc """
  Creates a jobs.

  ## Examples

      iex> create_jobs(%{field: value})
      {:ok, %Jobs{}}

      iex> create_jobs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_jobs(attrs \\ %{}) do
    %Jobs{}
    |> Jobs.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a jobs.

  ## Examples

      iex> update_jobs(jobs, %{field: new_value})
      {:ok, %Jobs{}}

      iex> update_jobs(jobs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_jobs(%Jobs{} = jobs, attrs) do
    jobs
    |> Jobs.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a jobs.

  ## Examples

      iex> delete_jobs(jobs)
      {:ok, %Jobs{}}

      iex> delete_jobs(jobs)
      {:error, %Ecto.Changeset{}}

  """
  def delete_jobs(%Jobs{} = jobs) do
    Repo.delete(jobs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking jobs changes.

  ## Examples

      iex> change_jobs(jobs)
      %Ecto.Changeset{data: %Jobs{}}

  """
  def change_jobs(%Jobs{} = jobs, attrs \\ %{}) do
    Jobs.changeset(jobs, attrs)
  end

  def get_jobs_by_user(user) do
    Jobs.Query.user_jobs(user) |> Repo.all()
  end
end
