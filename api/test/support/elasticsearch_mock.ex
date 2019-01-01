defmodule Dojinlist.ElasticsearchMock do
  @behaviour Elasticsearch.API

  @impl true
  def request(_config, _method, _path, _data, _opts) do
    {:ok,
     %HTTPoison.Response{
       status_code: 404,
       body: %{
         "status" => "not_found"
       }
     }}
  end
end
