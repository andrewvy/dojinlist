defmodule Dojinlist.AlbumSearch do
  def match_name(input) do
    %{
      "match_phrase" => %{
        "name" => input
      }
    }
  end

  def match_kana_name(input) do
    %{
      "match_phrase" => %{
        "kana_name" => input
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

  def with_name(input) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => match_name(input)
    })
  end

  def with_kana_name(input) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => match_kana_name(input)
    })
  end

  def with_name_suggest(input) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "suggest" => %{
        "name_suggest" => %{
          "prefix" => input,
          "completion" => %{
            "field" => "name_suggest"
          }
        }
      }
    })
  end

  def with_name_and_artists(query, ids) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => %{
        "bool" => %{
          "must" => match_name(query),
          "filter" => match_terms("artists", ids)
        }
      }
    })
  end

  def with_name_and_genres(query, ids) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => %{
        "bool" => %{
          "must" => match_name(query),
          "filter" => match_terms("genres", ids)
        }
      }
    })
  end
end
