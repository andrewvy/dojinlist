defmodule DojinlistWeb.Mutations.CheckoutTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  test "Purchase a non-existent album returns error" do
    query = """
    mutation CheckoutAlbum($albumId: ID!, $token: String!, $userEmail: String) {
      checkoutAlbum(albumId: $albumId, token: $token, userEmail: $userEmail) {
        errors {
          errorCode
          errorMessage
        }
      }
    }
    """

    album_id = Absinthe.Relay.Node.to_global_id(:album, 1, DojinlistWeb.Schema)

    variables = %{
      albumId: album_id,
      token: "tok_visa",
      userEmail: "test@test.com"
    }

    response =
      build_conn()
      |> execute_graphql(query, variables)

    assert %{
             "data" => %{
               "checkoutAlbum" => %{
                 "errors" => [
                   %{
                     "errorCode" => "ALBUM_NOT_FOUND"
                   }
                 ]
               }
             }
           } = response
  end

  test "Purchase an album with an email" do
    query = """
    mutation CheckoutAlbum($albumId: ID!, $token: String!, $userEmail: String) {
      checkoutAlbum(albumId: $albumId, token: $token, userEmail: $userEmail) {
        errors {
          errorCode
          errorMessage
        }
      }
    }
    """

    {:ok, album} =
      Fixtures.album(%{
        price: Money.from_integer(1200, :usd)
      })

    album_id = Absinthe.Relay.Node.to_global_id(:album, album.id, DojinlistWeb.Schema)

    variables = %{
      albumId: album_id,
      token: "tok_visa",
      userEmail: "test@test.com"
    }

    response =
      build_conn()
      |> execute_graphql(query, variables)

    assert %{
             "data" => %{
               "checkoutAlbum" => %{
                 "errors" => nil
               }
             }
           } = response
  end

  test "Purchase an album with an logged-in user account" do
    query = """
    mutation CheckoutAlbum($albumId: ID!, $token: String!, $userEmail: String) {
      checkoutAlbum(albumId: $albumId, token: $token, userEmail: $userEmail) {
        errors {
          errorCode
          errorMessage
        }
      }
    }
    """

    {:ok, user} = Fixtures.user()

    {:ok, album} =
      Fixtures.album(%{
        price: Money.from_integer(1200, :usd)
      })

    album_id = Absinthe.Relay.Node.to_global_id(:album, album.id, DojinlistWeb.Schema)

    variables = %{
      albumId: album_id,
      token: "tok_visa"
    }

    response =
      build_conn()
      |> Fixtures.login_as(user)
      |> execute_graphql(query, variables)

    assert %{
             "data" => %{
               "checkoutAlbum" => %{
                 "errors" => nil
               }
             }
           } = response
  end
end
