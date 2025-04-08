defmodule Jobsync.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JobsyncWeb.Telemetry,
      Jobsync.Repo,
      {DNSCluster, query: Application.get_env(:jobsync, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Jobsync.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Jobsync.Finch},
      # Start a worker by calling: Jobsync.Worker.start_link(arg)
      # {Jobsync.Worker, arg},
      # Start to serve requests, typically the last entry
      JobsyncWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jobsync.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JobsyncWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
