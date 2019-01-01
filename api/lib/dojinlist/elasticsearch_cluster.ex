defmodule Dojinlist.ElasticsearchCluster do
  use Elasticsearch.Cluster, otp_app: :dojinlist

  def init(default_config) do
    indexes = %{
      albums: %{
        settings: Application.app_dir(:dojinlist, "priv/elasticsearch/albums.json"),
        store: Dojinlist.ElasticsearchStore,
        sources: [Dojinlist.Schemas.Album],
        bulk_page_size: 5000,
        bulk_wait_interval: 15_000
      }
    }

    config =
      default_config
      |> Map.put(:indexes, indexes)

    {:ok, config}
  end
end
