defmodule Dojinlist.Albums do
  alias Ecto.Multi

  alias Dojinlist.{
    Repo,
    Schemas,
    Utility,
    Genres,
    Artists
  }

  import Ecto.Query

  def build_query(query, attrs) do
    Enum.reduce(attrs, query, fn attr, query ->
      build_query_from_attr(query, attr)
    end)
    |> distinct([o], o.id)
  end

  def build_query_from_attr(query, {:artist_ids, ids}) do
    ids = ids |> Enum.map(&Utility.parse_integer/1) |> Enum.dedup()

    query
    |> join(:left, [o], a in Schemas.AlbumArtist, on: a.album_id == o.id)
    |> where([o, a], a.artist_id in ^ids)
  end

  def build_query_from_attr(query, {:genre_ids, ids}) do
    ids = ids |> Enum.map(&Utility.parse_integer/1) |> Enum.dedup()

    query
    |> join(:left, [o], g in Schemas.AlbumGenre, on: g.album_id == o.id)
    |> where([o, g], g.genre_id in ^ids)
  end

  def build_query_from_attr(query, {:artist_names, names}) do
    ids = Artists.get_by_names(names) |> Enum.map(& &1.id)

    query
    |> join(:left, [o], a in Schemas.AlbumArtist, on: a.album_id == o.id)
    |> where([o, a], a.artist_id in ^ids)
  end

  def build_query_from_attr(query, {:genre_names, names}) do
    ids = Genres.get_by_names(names) |> Enum.map(& &1.id)

    query
    |> join(:left, [o], g in Schemas.AlbumGenre, on: g.album_id == o.id)
    |> where([o, g], g.genre_id in ^ids)
  end

  def build_query_from_attr(query, _), do: query

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
