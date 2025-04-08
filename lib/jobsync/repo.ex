defmodule Jobsync.Repo do
  use Ecto.Repo,
    otp_app: :jobsync,
    adapter: Ecto.Adapters.Postgres
end
