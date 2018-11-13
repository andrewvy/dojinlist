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
  pool: Ecto.Adapters.SQL.Sandbox

config :dojinlist, Dojinlist.ElasticsearchCluster, api: Dojinlist.ElasticsearchMock
