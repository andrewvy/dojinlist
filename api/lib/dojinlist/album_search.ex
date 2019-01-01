defmodule Dojinlist.AlbumSearch do
  def match_romanized_title(input) do
    %{
      "match_phrase" => %{
        "romanized_title" => input
      }
    }
  end

  def match_japanese_title(input) do
    %{
      "match_phrase" => %{
        "japanese_title" => input
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

  def with_romanized_title(input) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => match_romanized_title(input)
    })
  end

  def with_japanese_title(input) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => match_japanese_title(input)
    })
  end

  def with_romanized_title_suggest(input) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "suggest" => %{
        "romanized_title_suggest" => %{
          "prefix" => input,
          "completion" => %{
            "field" => "romanized_title_suggest"
          }
        }
      }
    })
  end

  def with_romanized_title_and_artists(query, ids) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => %{
        "bool" => %{
          "must" => match_romanized_title(query),
          "filter" => match_terms("artists", ids)
        }
      }
    })
  end

  def with_romanized_title_and_genres(query, ids) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => %{
        "bool" => %{
          "must" => match_romanized_title(query),
          "filter" => match_terms("genres", ids)
        }
      }
    })
  end

  def with_track_romanized_title(track_romanized_title) do
    Elasticsearch.post(Dojinlist.ElasticsearchCluster, "/albums/_doc/_search", %{
      "query" => %{
        "nested" => %{
          "path" => "tracks",
          "query" => %{
            "match_phrase" => %{
              "tracks.romanized_title" => track_romanized_title
            }
          }
        }
      }
    })
  end
end
