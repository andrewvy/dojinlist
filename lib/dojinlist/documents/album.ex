defimpl Elasticsearch.Document, for: Dojinlist.Schemas.Album do
  def id(album), do: album.id
  def routing(_), do: false

  def encode(album) do
    %{
      romanized_title: album.romanized_title,
      romanized_title_suggest: %{
        input: [
          album.romanized_title
        ]
      },
      artists: Enum.map(album.artists, & &1.id),
      genres: Enum.map(album.genres, & &1.id),
      tracks: Enum.map(album.tracks, &encode_track(&1)),
      event_id: album.event_id
    }
    |> add_japanese_title(album)
  end

  def encode_track(track) do
    %{
      romanized_title: track.romanized_title,
      japanese_title: track.japanese_title,
      play_length: track.play_length
    }
  end

  def add_japanese_title(doc, %{japanese_title: nil}), do: doc
  def add_japanese_title(doc, %{japanese_title: ""}), do: doc

  def add_japanese_title(doc, album) do
    %{
      japanese_title: album.japanese_title,
      japanese_title_suggest: %{
        input: [
          album.japanese_title
        ]
      }
    }
    |> Map.merge(doc)
  end
end
