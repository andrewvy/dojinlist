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
end
