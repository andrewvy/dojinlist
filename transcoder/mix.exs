defmodule Transcoder.MixProject do
  use Mix.Project

  def project do
    [
      app: :transcoder,
      version: "0.0.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Transcoder.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aws, "~> 2.1", override: true},
      {:ex_aws_s3, "~> 2.0"},
      {:ex_aws_sqs, "~> 2.0"},
      {:poison, "~> 3.0"},
      {:hackney, "~> 1.9"},
      {:briefly,
       git: "git@github.com:CargoSense/briefly.git",
       ref: "c7a6b5438536fbcef025e2c15b59ee3f462171eb"},
      {:sweet_xml, "~> 0.6"},
      {:gen_stage, "~> 0.14"},
      {:vex, "~> 0.8.0"},
      {:jason, "~> 1.1"},
      {:distillery, "~> 2.0"}

      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end
end
