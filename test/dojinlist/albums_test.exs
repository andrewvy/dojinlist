defmodule Dojinlist.AlbumsTest do
  use Dojinlist.DataCase

  alias Dojinlist.{
    Artists,
    Genres,
    Albums,
    Repo
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

    assert 1 == Enum.count(album.genres)
  end

  test "Can mark an album as verified" do
    {:ok, album} = Dojinlist.Fixtures.album()

    assert album.is_verified == false
    assert {:ok, album} = Albums.mark_as_verified(album.id)
    assert album.is_verified == true
  end

  test "Can mark an album as unverified" do
    {:ok, album} = Dojinlist.Fixtures.album(%{is_verified: true})

    assert album.is_verified == true
    assert {:ok, album} = Albums.mark_as_unverified(album.id)
    assert album.is_verified == false
  end

  test "Can update an album" do
    {:ok, album} = Dojinlist.Fixtures.album()
    {:ok, artist} = Artists.create_artist(%{name: "DJ Test"})
    {:ok, genre} = Genres.create_genre(%{name: "Electronic"})

    assert {:ok, updated_album} =
             Albums.update_album(album, %{
               name: "Test",
               artist_ids: [artist.id],
               genre_ids: [genre.id]
             })

    assert album.name != updated_album.name
    assert 1 = Enum.count(updated_album.artists)
    assert 1 = Enum.count(updated_album.genres)
  end

  test "Edit history is created for album submission/edits" do
    {:ok, user} = Dojinlist.Fixtures.user()
    {:ok, album} = Albums.create_album(%{name: "Test", creator_user_id: user.id})

    Albums.update_album(album, %{name: "New Name"}, user.id)

    loaded_album = album |> Repo.preload([:edit_history])

    assert 2 == Enum.count(loaded_album.edit_history)
  end

  test "Can add external album links" do
    {:ok, album} =
      Albums.create_album(%{
        name: "External Album Link",
        external_links: [
          %{
            url: "https://",
            type: "store_digital_only"
          }
        ]
      })

    album = Repo.preload(album, [:external_links])

    assert 1 == Enum.count(album.external_links)
  end

  test "Can replace external album links" do
    {:ok, album} =
      Albums.create_album(%{
        name: "External Album Link",
        external_links: [
          %{
            url: "https://external-album.link/1",
            type: "store_digital_only"
          }
        ]
      })

    album = Repo.preload(album, [:external_links])
    [external_link] = album.external_links

    assert "https://external-album.link/1" == external_link.url

    {:ok, album} =
      Albums.update_album(album, %{
        external_links: [
          %{
            Map.from_struct(external_link)
            | url: "https://external-album.link/2"
          }
        ]
      })

    album = Repo.preload(album, [:external_links])
    [external_link] = album.external_links

    assert 1 == Enum.count(album.external_links)
    assert "https://external-album.link/2" == external_link.url
  end
end
