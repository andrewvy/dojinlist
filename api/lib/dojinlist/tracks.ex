defmodule Dojinlist.Tracks do
  alias Dojinlist.{
    Repo,
    Schemas
  }

  alias Dojinlist.Audio

  @spec validate_and_merge_attrs(map, Plug.Upload.t()) :: {:ok, map} | {:error, any}
  def validate_and_merge_attrs(attrs, nil), do: {:ok, attrs}

  def validate_and_merge_attrs(attrs, file) do
    with {:ok, streams} <- Audio.probe(file),
         true <- Audio.qualified_audio?(streams) do
      audio_stream = Audio.get_audio_stream(streams)
      {duration, _} = Float.parse(audio_stream.duration)

      {:ok, Map.merge(attrs, %{play_length: round(duration)})}
    else
      _ ->
        {:error, :audio_not_supported}
    end
  end

  def create_track(album_id, attrs) do
    merged_attrs =
      %{
        album_id: album_id
      }
      |> Map.merge(attrs)

    %Schemas.Track{}
    |> Schemas.Track.changeset(merged_attrs)
    |> Repo.insert()
  end

  def get_by_id(id) do
    Schemas.Track
    |> Repo.get(id)
    |> Repo.preload([:album])
  end

  def update_track(track, attrs) do
    track
    |> Schemas.Track.changeset(attrs)
    |> Repo.update()
  end
end
