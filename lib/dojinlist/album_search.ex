defmodule Dojinlist.AlbumSearch do
  def search(query) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => %{
        "match_phrase" => %{
          "name" => query
        }
      }
    })
  end
end
