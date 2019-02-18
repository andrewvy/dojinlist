defmodule DojinlistWeb.Mutations.StorefrontTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  test "Can create a storefront" do
    query = """
    mutation CreateStorefront($storefront: StorefrontInput) {
      createStorefront(storefront: $storefront) {
        id
        displayName
        description
        location
      }
    }
    """

    variables = %{
      storefront: %{
        slug: "bitplane",
        displayName: "Bitplane",
        description: """
        Making music.
        """,
        location: "Tokyo, Japan"
      }
    }

    response =
      build_conn()
      |> Fixtures.create_and_login_as_admin()
      |> execute_graphql(query, variables)

    assert %{
             "data" => %{
               "createStorefront" => %{
                 "id" => _,
                 "displayName" => "Bitplane",
                 "location" => "Tokyo, Japan"
               }
             }
           } = response
  end
end
