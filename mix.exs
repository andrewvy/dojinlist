defmodule Dojinlist.MixProject do
  use Mix.Project

  def project do
    [
      app: :dojinlist,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Dojinlist.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:absinthe, "~> 1.5.0-alpha.0", override: true},
      {:absinthe_plug, "~> 1.4.6"},
      {:absinthe_relay, github: "absinthe-graphql/absinthe_relay"},
      {:arc, "~> 0.11.0"},
      {:argon2_elixir, "~> 1.2"},
      {:corsica, "~> 1.0"},
      {:dataloader, "~> 1.0.0"},
      {:distillery, "~> 2.0"},
      {:ecto, "~> 3.0", override: true},
      {:ecto_sql, "~> 3.0"},
      {:edeliver, ">= 1.6.0"},
      {:elasticsearch, "~> 0.6.0"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_s3, "~> 2.0"},
      {:faker, "~> 0.11.0", only: :test},
      {:gen_smtp, "~> 0.13.0"},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.6"},
      {:httpoison, ">= 0.0.0"},
      {:jason, "~> 1.0"},
      {:joken, "~> 2.0-rc2"},
      {:paginator, "~> 0.5"},
      {:phoenix, "~> 1.4.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:swoosh, "~> 0.20"},
      {:postgrex, ">= 0.0.0"},
      {:sweet_xml, "~> 0.6"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
