defmodule Dojinlist.AlbumsTest do
  use Dojinlist.DataCase

  alias Dojinlist.{
    Albums,
    Artists,
    Fixtures,
    Genres,
    Repo
  }

  setup do
    {:ok, storefront} = Fixtures.storefront()

    {:ok, storefront: storefront}
  end

  test "Can create a new album", %{storefront: storefront} do
    assert {:ok, album} =
             Albums.create_album(%{
               japanese_title: "02 EP",
               sample_url: "https://02-ep.local/sample.mp3",
               purchase_url: "https://02-ep.local",
               storefront_id: storefront.id
             })
  end

  test "Can create a new album with artists", %{storefront: storefront} do
    {:ok, artist} = Artists.create_artist(%{name: "DJ Test"})

    assert {:ok, album} =
             Albums.create_album(%{
               japanese_title: "02 EP",
               sample_url: "https://02-ep.local/sample.mp3",
               storefront_id: storefront.id,
               purchase_url: "https://02-ep.local",
               artist_ids: [artist.id]
             })

    assert 1 == Enum.count(album.artists)
  end

  test "Can create a new album with genres", %{storefront: storefront} do
    {:ok, genre} = Genres.create_genre(%{name: "Electronic"})

    assert {:ok, album} =
             Albums.create_album(%{
               japanese_title: "02 EP",
               sample_url: "https://02-ep.local/sample.mp3",
               storefront_id: storefront.id,
               purchase_url: "https://02-ep.local",
               genre_ids: [genre.id]
             })

    assert 1 == Enum.count(album.genres)
  end

  test "Can mark an album as verified" do
    {:ok, album} = Fixtures.album()

    assert album.is_verified == false
    assert {:ok, album} = Albums.mark_as_verified(album.id)
    assert album.is_verified == true
  end

  test "Can mark an album as unverified" do
    {:ok, album} = Fixtures.album(%{is_verified: true})

    assert album.is_verified == true
    assert {:ok, album} = Albums.mark_as_unverified(album.id)
    assert album.is_verified == false
  end

  test "Can update an album" do
    {:ok, album} = Fixtures.album()
    {:ok, artist} = Artists.create_artist(%{name: "DJ Test"})
    {:ok, genre} = Genres.create_genre(%{name: "Electronic"})

    assert {:ok, updated_album} =
             Albums.update_album(album, %{
               japanese_title: "Test",
               artist_ids: [artist.id],
               genre_ids: [genre.id]
             })

    assert album.japanese_title != updated_album.japanese_title
    assert 1 = Enum.count(updated_album.artists)
    assert 1 = Enum.count(updated_album.genres)
  end

  test "Edit history is created for album submission/edits", %{storefront: storefront} do
    {:ok, user} = Fixtures.user()

    {:ok, album} =
      Albums.create_album(%{
        japanese_title: "Test",
        creator_user_id: user.id,
        storefront_id: storefront.id
      })

    Albums.update_album(album, %{japanese_title: "New Name"}, user.id)

    loaded_album = album |> Repo.preload([:edit_history])

    assert 2 == Enum.count(loaded_album.edit_history)
  end

  test "Can add external album links", %{storefront: storefront} do
    {:ok, album} =
      Albums.create_album(%{
        japanese_title: "External Album Link",
        storefront_id: storefront.id,
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

  test "Can replace external album links", %{storefront: storefront} do
    {:ok, album} =
      Albums.create_album(%{
        japanese_title: "External Album Link",
        storefront_id: storefront.id,
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
