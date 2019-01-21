use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :dojinlist, DojinlistWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :dojinlist, Dojinlist.Repo,
  username: "postgres",
  password: "postgres",
  database: "dojinlist_test",
  hostname: "localhost",
  timeout: 360_000,
  ownership_timeout: 360_000,
  pool: Ecto.Adapters.SQL.Sandbox

config :argon2_elixir, t_cost: 2, m_cost: 8

config :dojinlist, Dojinlist.ElasticsearchCluster, api: Dojinlist.ElasticsearchMock

config :dojinlist,
  payment_adapter: Dojinlist.Payments.Test,
  tax_adapter: Dojinlist.Tax.TestAdapter
