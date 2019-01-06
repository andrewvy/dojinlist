defmodule Transcoder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: Transcoder.Worker.start_link(arg)
      # {Transcoder.Worker, arg},
      {Transcoder.SQS.Producer, {"transcoder_jobs", [name: :producer_1]}},
      {Transcoder.SQS.Consumer, {"transcoder_jobs", [:producer_1]}}
    ]

    Logger.info("Started Transcoder Application")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Transcoder.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
