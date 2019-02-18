defmodule DojinlistWeb.Resolvers.StorefrontTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  @query """
    query StorefrontBySlug($slug: String!) {
      storefront(slug: $slug) {
        id
      }
    }
  """

  test "Can search for a storefront by slug" do
    {:ok, storefront} = Fixtures.storefront(%{slug: "test-alpha"})

    conn =
      build_conn()
      |> Fixtures.create_and_login_as_admin()

    response =
      conn
      |> execute_graphql(@query, %{slug: "test-alpha"})

    storefront_id =
      Absinthe.Relay.Node.to_global_id(:storefront, storefront.id, DojinlistWeb.Schema)

    assert %{"data" => %{"storefront" => %{"id" => response_storefront_id}}} = response
    assert response_storefront_id == storefront_id
  end
end
