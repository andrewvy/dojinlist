defmodule Dojinlist.Tracks do
  alias Dojinlist.{
    Repo,
    Schemas
  }

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
  end

  def update_track(track, attrs) do
    %Schemas.Track{}
    |> Schemas.Track.changeset(attrs)
    |> Repo.update()
  end
end
