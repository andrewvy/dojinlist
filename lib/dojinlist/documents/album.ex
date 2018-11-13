defimpl Elasticsearch.Document, for: Dojinlist.Schemas.Album do
  def id(album), do: album.id
  def routing(_), do: false

  def encode(album) do
    %{
      name: album.name,
      sample_url: album.sample_url,
      purchase_url: album.purchase_url
    }
  end
end
