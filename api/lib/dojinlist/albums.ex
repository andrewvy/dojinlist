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

  def build_query_from_attr(query, {:event_id, id}) do
    id = id |> Utility.parse_integer()

    query
    |> where([a], a.event_id == ^id)
  end

  def build_query_from_attr(query, {:storefront_id, id}) do
    id = id |> Utility.parse_integer()

    query
    |> where([a], a.storefront_id == ^id)
  end

  def build_query_from_attr(query, _), do: query

  def create_album(attrs) do
    artist_ids =
      List.wrap(attrs[:artist_ids]) |> Enum.map(&Utility.parse_integer/1) |> Enum.dedup()

    genre_ids = List.wrap(attrs[:genre_ids]) |> Enum.map(&Utility.parse_integer/1) |> Enum.dedup()

    album_changeset = Schemas.Album.changeset(%Schemas.Album{}, attrs)

    Multi.new()
    |> Multi.insert(:album, album_changeset)
    |> insert_artists_and_genres(artist_ids, genre_ids)
    |> Repo.transaction()
    |> case do
      {:ok, multi} ->
        loaded_album =
          Schemas.Album
          |> where([o], o.id == ^multi[:album].id)
          |> Schemas.Album.preload()
          |> Repo.one()

        {:ok, loaded_album}

      {:error, _field, changeset, _} ->
        {:error, changeset}
    end
  end

  def insert_artists_and_genres(multi, artist_ids, genre_ids) do
    multi
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
  end

  def update_album(album, attrs) do
    artist_ids =
      List.wrap(attrs[:artist_ids]) |> Enum.map(&Utility.parse_integer/1) |> Enum.dedup()

    genre_ids = List.wrap(attrs[:genre_ids]) |> Enum.map(&Utility.parse_integer/1) |> Enum.dedup()

    album_changeset = Schemas.Album.changeset(album, attrs)

    Multi.new()
    |> Multi.update(:album, album_changeset)
    |> Multi.delete_all(
      :deleted_album_artists,
      from(o in Schemas.AlbumArtist, where: o.album_id == ^album.id)
    )
    |> Multi.delete_all(
      :deleted_album_genres,
      from(o in Schemas.AlbumGenre, where: o.album_id == ^album.id)
    )
    |> insert_artists_and_genres(artist_ids, genre_ids)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        loaded_album =
          Schemas.Album
          |> where([o], o.id == ^album.id)
          |> Schemas.Album.preload()
          |> Repo.one()

        {:ok, loaded_album}

      {:error, _field, changeset, _} ->
        {:error, changeset}
    end
  end

  def get_album(id) do
    Schemas.Album
    |> Repo.get(id)
    |> Repo.preload([:tracks])
  end

  def get_album_by_slug(slug) do
    Schemas.Album
    |> Repo.get_by(slug: slug)
    |> Repo.preload([:tracks])
  end
end
