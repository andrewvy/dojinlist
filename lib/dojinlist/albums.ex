defmodule Dojinlist.Albums do
  alias Ecto.Multi

  import Ecto.Query

  alias Dojinlist.{
    Repo,
    Schemas,
    Utility
  }

  def create_album(attrs) do
    artist_ids =
      List.wrap(attrs[:artist_ids]) |> Enum.map(&Utility.parse_integer/1) |> Enum.dedup()

    genre_ids = List.wrap(attrs[:genre_ids]) |> Enum.map(&Utility.parse_integer/1) |> Enum.dedup()

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
      {:error, _field, changeset, _} -> {:error, changeset}
    end
  end

  def get_album(id) do
    Schemas.Album
    |> Repo.get(id)
  end

  def mark_as_verified(id) do
    get_album(id)
    |> case do
      nil ->
        {:error, "Could not find an album with that ID."}

      album ->
        album
        |> Schemas.Album.changeset(%{is_verified: true})
        |> Repo.update()
    end
  end

  def mark_as_unverified(id) do
    get_album(id)
    |> case do
      nil ->
        {:error, "Could not find an album with that ID."}

      album ->
        album
        |> Schemas.Album.changeset(%{is_verified: false})
        |> Repo.update()
    end
  end
end
