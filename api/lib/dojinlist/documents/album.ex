defimpl Elasticsearch.Document, for: Dojinlist.Schemas.Album do
  def id(album), do: album.id
  def routing(_), do: false

  def encode(album) do
    %{
      title: album.title,
      title_suggest: %{
        input: [
          album.title
        ]
      },
      japanese_title_suggest: %{
        input: [
          album.title
        ]
      },
      artists: Enum.map(album.artists, & &1.id),
      genres: Enum.map(album.genres, & &1.id),
      tracks: Enum.map(album.tracks, &encode_track(&1)),
      event_id: album.event_id
    }
  end

  def encode_track(track) do
    %{
      title: track.title,
      play_length: track.play_length
    }
  end
end
