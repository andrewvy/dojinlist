defmodule Dojinlist.AlbumSearch do
  def match_title(input) do
    %{
      "match_phrase" => %{
        "title" => input
      }
    }
  end

  def match_terms(type, ids) do
    %{
      "terms" => %{
        type => ids
      }
    }
  end

  def with_title(input) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => match_title(input)
    })
  end

  def with_title_suggest(input) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "suggest" => %{
        "title_suggest" => %{
          "prefix" => input,
          "completion" => %{
            "field" => "title_suggest"
          }
        }
      }
    })
  end
end
