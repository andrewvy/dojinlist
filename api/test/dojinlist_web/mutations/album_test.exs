defmodule DojinlistWeb.Mutations.AlbumTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  test "Can create an album" do
    query = """
    mutation CreateAlbum($album: AlbumInput) {
      createAlbum(album: $album) {
        album {
          id
        }
      }
    }
    """

    {:ok, user} = Fixtures.user()

    storefront_id =
      Absinthe.Relay.Node.to_global_id(:storefront, user.storefront_id, DojinlistWeb.Schema)

    variables = %{
      album: %{
        title: "GraphQL Album Test",
        storefront_id: storefront_id,
        slug: "graphql-album-test",
        price: "USD 9.99"
      }
    }

    response =
      build_conn()
      |> Fixtures.login_as(user)
      |> execute_graphql(query, variables)

    assert %{"data" => %{"createAlbum" => %{"album" => %{"id" => _}}}} = response
  end

  test "Can update an album" do
    query = """
    mutation UpdateAlbum($album: AlbumInput, $albumId: ID!) {
      updateAlbum(album: $album, albumId: $albumId) {
        album {
          id
          title
          slug
        }
      }
    }
    """

    {:ok, user} = Fixtures.user()

    {:ok, album} =
      Fixtures.album(%{
        storefront_id: user.storefront.id,
        title: "Update Album Test",
        slug: "update-album-test"
      })

    album_id = Absinthe.Relay.Node.to_global_id(:album, album.id, DojinlistWeb.Schema)

    variables = %{
      album: %{
        title: "Updated",
        storefront_id: user.storefront.id,
        slug: "updated"
      },
      albumId: album_id
    }

    response =
      build_conn()
      |> Fixtures.login_as(user)
      |> execute_graphql(query, variables)

    assert %{
             "data" => %{
               "updateAlbum" => %{
                 "album" => %{"id" => ^album_id, "title" => "Updated", "slug" => "updated"}
               }
             }
           } = response
  end

  test "Can create an album with external links" do
    query = """
    mutation CreateAlbum($album: AlbumInput) {
      createAlbum(album: $album) {
        album {
          id
          externalLinks {
            url
            type
          }
        }
      }
    }
    """

    {:ok, user} = Fixtures.user()

    storefront_id =
      Absinthe.Relay.Node.to_global_id(:storefront, user.storefront_id, DojinlistWeb.Schema)

    variables = %{
      album: %{
        title: "GraphQL Album Test",
        slug: "graphql-album-test",
        storefront_id: storefront_id,
        external_links: [
          %{
            url: "https://test.com",
            type: "OFFICIAL"
          }
        ]
      }
    }

    response =
      build_conn()
      |> Fixtures.login_as(user)
      |> execute_graphql(query, variables)

    assert %{"data" => %{"createAlbum" => %{"album" => %{"id" => _}}}} = response

    assert "https://test.com" =
             get_in(response, [
               "data",
               "createAlbum",
               "album",
               "externalLinks",
               Access.at(0),
               "url"
             ])
  end

  test "Can delete an album" do
    query = """
    mutation DeleteAlbum($albumId: ID!) {
      deleteAlbum(albumId: $albumId) {
        albumId
      }
    }
    """

    {:ok, user} = Fixtures.user()

    {:ok, album} =
      Fixtures.album(%{
        storefront_id: user.storefront.id,
        title: "Update Album Test",
        slug: "update-album-test"
      })

    album_id = Absinthe.Relay.Node.to_global_id(:album, album.id, DojinlistWeb.Schema)

    variables = %{
      albumId: album_id
    }

    response =
      build_conn()
      |> Fixtures.login_as(user)
      |> execute_graphql(query, variables)

    assert %{
             "data" => %{
               "deleteAlbum" => %{
                 "albumId" => ^album_id
               }
             }
           } = response
  end
end
