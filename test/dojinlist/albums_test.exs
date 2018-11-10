defmodule Dojinlist.AlbumsTest do
  use Dojinlist.DataCase

  alias Dojinlist.{
    Artists,
    Genres,
    Albums
  }

  test "Can create a new album" do
    assert {:ok, album} =
             Albums.create_album(%{
               name: "02 EP",
               sample_url: "https://02-ep.local/sample.mp3",
               purchase_url: "https://02-ep.local"
             })
  end

  test "Can create a new album with artists" do
    {:ok, artist} = Artists.create_artist(%{name: "DJ Test"})

    assert {:ok, album} =
             Albums.create_album(%{
               name: "02 EP",
               sample_url: "https://02-ep.local/sample.mp3",
               purchase_url: "https://02-ep.local",
               artist_ids: [artist.id]
             })

    album = album |> Repo.preload(:artists)

    assert 1 == Enum.count(album.artists)
  end

  test "Can create a new album with genres" do
    {:ok, genre} = Genres.create_genre(%{name: "Electronic"})

    assert {:ok, album} =
             Albums.create_album(%{
               name: "02 EP",
               sample_url: "https://02-ep.local/sample.mp3",
               purchase_url: "https://02-ep.local",
               genre_ids: [genre.id]
             })

    album = album |> Repo.preload(:genres)

    assert 1 == Enum.count(album.genres)
  end
end
