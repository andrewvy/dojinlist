defimpl Elasticsearch.Document, for: Dojinlist.Schemas.Album do
  def id(album), do: album.id
  def routing(_), do: false

  def encode(album) do
    %{
      name: album.name,
      name_suggest: %{
        input: [
          album.name
        ]
      },
      artists: Enum.map(album.artists, & &1.id),
      genres: Enum.map(album.genres, & &1.id),
      tracks: Enum.map(album.tracks, &encode_track(&1)),
      event_id: album.event_id
    }
    |> add_kana_name(album)
  end

  def encode_track(track) do
    %{
      title: track.title,
      kana_title: track.kana_title,
      play_length: track.play_length
    }
  end

  def add_kana_name(doc, %{kana_name: nil}), do: doc
  def add_kana_name(doc, %{kana_name: ""}), do: doc

  def add_kana_name(doc, album) do
    %{
      kana_name: album.kana_name,
      kana_name_suggest: %{
        input: [
          album.kana_name
        ]
      }
    }
    |> Map.merge(doc)
  end
end
