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

config :dojinlist, Dojinlist.ElasticsearchCluster,
  # The URL where Elasticsearch is hosted on your system
  url: "http://localhost:9200",

  # If your Elasticsearch cluster uses HTTP basic authentication,
  # specify the username and password here:
  username: "elastic",
  password: "changeme",
  api: Elasticsearch.API.HTTP,
  json_library: Jason,

  # You should configure each index which you maintain in Elasticsearch here.
  # This configuration will be read by the `mix elasticsearch.build` task,
  # described below.
  indexes: %{
    # This is the base name of the Elasticsearch index. Each index will be
    # built with a timestamp included in the name, like "posts-5902341238".
    # It will then be aliased to "posts" for easy querying.
    albums: %{
      # This file describes the mappings and settings for your index. It will
      # be posted as-is to Elasticsearch when you create your index, and
      # therefore allows all the settings you could post directly.
      settings: "priv/elasticsearch/albums.json",
      store: Dojinlist.ElasticsearchStore,

      # This is the list of data sources that should be used to populate this
      # index. The `:store` module above will be passed each one of these
      # sources for fetching.
      #
      # Each piece of data that is returned by the store must implement the
      # Elasticsearch.Document protocol.
      sources: [Dojinlist.Schemas.Album],

      # When indexing data using the `mix elasticsearch.build` task,
      # control the data ingestion rate by raising or lowering the number
      # of items to send in each bulk request.
      bulk_page_size: 5000,
      # 15 seconds
      bulk_wait_interval: 15_000
    }
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
