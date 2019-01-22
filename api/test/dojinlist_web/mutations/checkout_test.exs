defmodule DojinlistWeb.Mutations.CheckoutTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  test "Can get a cart total for an album" do
    query = """
    mutation GetTotalsForAlbum($albumId: ID!) {
      calculateTotalsForAlbum(albumId: $albumId) {
        cartTotals {
          subTotal {
            amount
            currency
          }
          shippingTotal {
            amount
            currency
          }
          taxTotal {
            amount
            currency
          }
          grandTotal {
            amount
            currency
          }
        }
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
      albumId: album_id
    }

    response =
      build_conn()
      |> execute_graphql(query, variables)

    assert %{
             "data" => %{
               "calculateTotalsForAlbum" => %{
                 "cartTotals" => %{
                   "subTotal" => %{
                     "amount" => "$12.00"
                   },
                   "grandTotal" => %{
                     "amount" => "$12.00"
                   }
                 }
               }
             }
           } = response
  end

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
