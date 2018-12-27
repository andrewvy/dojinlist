defmodule DojinlistWeb.Mutations.StorefrontTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  test "Can create a storefront" do
    query = """
    mutation CreateStorefront($storefront: StorefrontInput) {
      createStorefront(storefront: $storefront) {
        id
      }
    }
    """

    variables = %{
      storefront: %{
        subdomain: "test"
      }
    }

    response =
      build_conn()
      |> Fixtures.create_and_login_as_admin()
      |> execute_graphql(query, variables)

    assert %{"data" => %{"createStorefront" => %{"id" => _}}} = response
  end
end
