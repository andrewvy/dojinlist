defmodule Dojinlist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    Application.put_env(:stripity_stripe, :api_key, System.get_env("STRIPE_API_KEY"))

    # List all child processes to be supervised
    children = [
      {
        ConCache,
        [
          name: :tax_cache,
          ttl_check_interval: :timer.seconds(1),
          global_ttl: :timer.hours(24)
        ]
      },
      Dojinlist.Repo,
      DojinlistWeb.Endpoint,
      Dojinlist.Ratings.Store
    ]

    sqs_children = get_sqs_children()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dojinlist.Supervisor]
    Supervisor.start_link(children ++ sqs_children, opts)
  end

  def get_sqs_children() do
    sqs_enabled? = Application.fetch_env!(:dojinlist, :sqs_enabled?)

    if sqs_enabled? do
      [
        Supervisor.child_spec(
          {Dojinlist.Transcoder.Producer,
           {"transcoder_jobs_successful", [name: :transcoder_successful_producer]}},
          id: :transcoder_successful_producer
        ),
        Supervisor.child_spec(
          {Dojinlist.Transcoder.Consumer,
           {"transcoder_jobs_successful", [:transcoder_successful_producer]}},
          id: :transcoder_successful_consumer
        ),
        Supervisor.child_spec(
          {Dojinlist.Transcoder.Producer,
           {"transcoder_jobs_failed", [name: :transcoder_failed_producer]}},
          id: :transcoder_failed_producer
        ),
        Supervisor.child_spec(
          {Dojinlist.Transcoder.Consumer,
           {"transcoder_jobs_failed", [:transcoder_failed_producer]}},
          id: :transcoder_failed_consumer
        )
      ]
    else
      []
    end
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DojinlistWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
