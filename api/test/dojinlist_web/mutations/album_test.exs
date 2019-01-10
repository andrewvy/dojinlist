defmodule DojinlistWeb.Mutations.AlbumTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  test "Can create an album" do
    query = """
    mutation CreateAlbum($album: AlbumInput) {
      createAlbum(album: $album) {
        id
      }
    }
    """

    {:ok, storefront} = Fixtures.storefront()

    storefront_id =
      Absinthe.Relay.Node.to_global_id(:storefront, storefront.id, DojinlistWeb.Schema)

    variables = %{
      album: %{
        title: "GraphQL Album Test",
        storefront_id: storefront_id
      }
    }

    response =
      build_conn()
      |> Fixtures.create_and_login_as_admin()
      |> execute_graphql(query, variables)

    assert %{"data" => %{"createAlbum" => %{"id" => _}}} = response
  end

  test "Can create an album with external links" do
    query = """
    mutation CreateAlbum($album: AlbumInput) {
      createAlbum(album: $album) {
        id
        externalLinks {
          url
          type
        }
      }
    }
    """

    {:ok, storefront} = Fixtures.storefront()

    storefront_id =
      Absinthe.Relay.Node.to_global_id(:storefront, storefront.id, DojinlistWeb.Schema)

    variables = %{
      album: %{
        title: "GraphQL Album Test",
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
      |> Fixtures.create_and_login_as_admin()
      |> execute_graphql(query, variables)

    assert %{"data" => %{"createAlbum" => %{"id" => _}}} = response

    assert "https://test.com" =
             get_in(response, ["data", "createAlbum", "externalLinks", Access.at(0), "url"])
  end
end
