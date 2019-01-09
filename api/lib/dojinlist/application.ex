defmodule Dojinlist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Application.put_env(:stripity_stripe, :api_key, System.get_env("STRIPE_API_KEY"))

    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Dojinlist.Repo,
      # Start the endpoint when the application starts
      DojinlistWeb.Endpoint,
      Dojinlist.ElasticsearchCluster,
      Dojinlist.Ratings.Store
      # Starts a worker by calling: Dojinlist.Worker.start_link(arg)
      # {Dojinlist.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dojinlist.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DojinlistWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
