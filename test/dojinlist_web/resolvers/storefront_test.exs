defmodule DojinlistWeb.Resolvers.StorefrontTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  @query """
    query StorefrontBySubdomain($subdomain: String!) {
      storefront(subdomain: $subdomain) {
        id
      }
    }
  """

  test "Can search for a storefront by subdomain" do
    {:ok, storefront} = Fixtures.storefront(%{subdomain: "test-alpha"})

    conn =
      build_conn()
      |> Fixtures.create_and_login_as_admin()

    response =
      conn
      |> execute_graphql(@query, %{subdomain: "test-alpha"})

    storefront_id =
      Absinthe.Relay.Node.to_global_id(:storefront, storefront.id, DojinlistWeb.Schema)

    assert %{"data" => %{"storefront" => %{"id" => response_storefront_id}}} = response
    assert response_storefront_id == storefront_id
  end
end
