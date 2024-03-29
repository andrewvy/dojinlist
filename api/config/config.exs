# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dojinlist,
  ecto_repos: [Dojinlist.Repo]

# Configures the endpoint
config :dojinlist, DojinlistWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vbOHZFTDSyVVyeocYuZo337UYsBuErsfNmBTEgVe6ZuPxJe4BKdsrPO80v5loRMz",
  render_errors: [view: DojinlistWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Dojinlist.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :arc,
  storage: Arc.Storage.S3,
  bucket: "dojinlist-uploads"

config :dojinlist, Dojinlist.Mailer, adapter: Swoosh.Adapters.Local

config :dojinlist,
  web_url: "http://localhost:3000"

config :ex_money,
  default_cldr_backend: Dojinlist.Cldr

config :ex_cldr,
  default_locale: "en",
  json_library: Jason

config :dojinlist,
  payment_adapter: Dojinlist.Payments.Stripe,
  tax_adapter: Dojinlist.Tax.TestAdapter,
  sqs_enabled?: true

config :ex_money,
  open_exchange_rates_app_id: {:system, "OPEN_EXCHANGE_RATES_APP_ID"}

config :ex_taxjar,
  api_key: System.get_env("TAXJAR_API_KEY"),
  end_point: "https://api.taxjar.com/v2"

config :ex_aws,
  access_key_id: [{:system, "AWS_ACCESS_KEY_ID"}, :instance_role],
  secret_access_key: [{:system, "AWS_SECRET_ACCESS_KEY"}, :instance_role]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
