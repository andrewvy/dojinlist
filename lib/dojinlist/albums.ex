defmodule Dojinlist.Albums do
  alias Ecto.Multi

  alias Dojinlist.{
    Repo,
    Schemas
  }

  def create_album(attrs) do
    artist_ids = List.wrap(attrs[:artist_ids])
    genre_ids = List.wrap(attrs[:genre_ids])
    album_changeset = Schemas.Album.changeset(%Schemas.Album{}, attrs)

    Multi.new()
    |> Multi.insert(:album, album_changeset)
    |> Multi.merge(fn %{album: album} ->
      album_artists =
        Enum.map(artist_ids, fn artist_id ->
          %{artist_id: artist_id, album_id: album.id}
        end)

      album_genres =
        Enum.map(genre_ids, fn genre_id ->
          %{genre_id: genre_id, album_id: album.id}
        end)

      Multi.new()
      |> Multi.insert_all(:album_artists, Schemas.AlbumArtist, album_artists)
      |> Multi.insert_all(:album_genres, Schemas.AlbumGenre, album_genres)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, multi} -> {:ok, multi[:album]}
      {:error, _} = error -> error
    end
  end
end
