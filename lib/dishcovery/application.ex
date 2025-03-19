defmodule Dishcovery.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DishcoveryWeb.Telemetry,
      Dishcovery.Repo,
      {DNSCluster, query: Application.get_env(:dishcovery, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Dishcovery.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Dishcovery.Finch},
      # Start a worker by calling: Dishcovery.Worker.start_link(arg)
      # {Dishcovery.Worker, arg},
      # Start to serve requests, typically the last entry
      DishcoveryWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dishcovery.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DishcoveryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
