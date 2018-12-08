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

    variables = %{
      album: %{
        name: "GraphQL Album Test"
      }
    }

    response =
      build_conn()
      |> Fixtures.create_and_login_as_admin()
      |> post(@endpoint, %{query: query, variables: variables})
      |> json_response(200)

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

    variables = %{
      album: %{
        name: "GraphQL Album Test",
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
      |> post(@endpoint, %{query: query, variables: variables})
      |> json_response(200)

    assert %{"data" => %{"createAlbum" => %{"id" => _}}} = response

    assert "https://test.com" =
             get_in(response, ["data", "createAlbum", "externalLinks", Access.at(0), "url"])
  end
end
