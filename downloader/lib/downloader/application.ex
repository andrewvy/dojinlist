defmodule Downloader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  require Logger

  use Application

  def start(_type, _args) do
    port = port(System.get_env("PORT"))

    # List all child processes to be supervised
    children = [
      Plug.Cowboy.child_spec(scheme: :http, plug: Downloader.Router, options: [port: port])
    ]

    Logger.info("Listening on port: #{port}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Downloader.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @default_port 4001
  defp port(nil), do: @default_port
  defp port(""), do: @default_port

  defp port(port) do
    port
    |> Integer.parse()
    |> case do
      :error -> @default_port
      {integer, _} -> integer
    end
  end
end
