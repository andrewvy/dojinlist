defmodule DojinlistWeb.Resolvers.AlbumTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  @query """
    query SearchAlbums($eventId: ID) {
      albums(first: 25, event_id: $eventId) {
        edges {
          node {
            id
            title
            event {
              id
              name
            }
          }
        }
      }
    }
  """

  test "Can search for an album by event_id" do
    {:ok, event} = Fixtures.event()
    {:ok, _} = Fixtures.completed_album()
    {:ok, _} = Fixtures.completed_album(%{event_id: event.id})

    event_id = Absinthe.Relay.Node.to_global_id(:event, event.id, DojinlistWeb.Schema)

    variables = %{
      eventId: event_id
    }

    response =
      build_conn()
      |> Fixtures.create_and_login_as_admin()
      |> execute_graphql(@query, variables)

    assert %{"data" => %{"albums" => %{"edges" => [edge]}}} = response
    assert %{"node" => %{"event" => %{"id" => ^event_id}}} = edge
  end

  @query """
    query SearchAlbums($storefrontId: ID) {
      albums(first: 25, storefrontId: $storefrontId) {
        edges {
          node {
            id
            title
            event {
              id
              name
            }
          }
        }
      }
    }
  """

  test "Can search for albums by storefront_id" do
    {:ok, creator} = Fixtures.user()

    storefront = creator.storefront

    {:ok, _} = Fixtures.completed_album(%{storefront_id: storefront.id})
    {:ok, _} = Fixtures.completed_album(%{storefront_id: storefront.id})
    {:ok, _} = Fixtures.completed_album()

    storefront_id =
      Absinthe.Relay.Node.to_global_id(:storefront, storefront.id, DojinlistWeb.Schema)

    variables = %{
      storefrontId: storefront_id
    }

    response =
      build_conn()
      |> Fixtures.create_and_login_as_admin()
      |> execute_graphql(@query, variables)

    assert %{"data" => %{"albums" => %{"edges" => albums}}} = response
    assert 2 = Enum.count(albums)
  end

  test "Only completed published albums are searchable" do
    {:ok, creator} = Fixtures.user()

    storefront = creator.storefront

    {:ok, _} = Fixtures.completed_album(%{storefront_id: storefront.id})
    {:ok, _} = Fixtures.completed_album(%{storefront_id: storefront.id})
    {:ok, _} = Fixtures.completed_album(%{storefront_id: storefront.id, is_draft: true})

    storefront_id =
      Absinthe.Relay.Node.to_global_id(:storefront, storefront.id, DojinlistWeb.Schema)

    variables = %{
      storefrontId: storefront_id
    }

    response =
      build_conn()
      |> Fixtures.create_and_login_as_admin()
      |> execute_graphql(@query, variables)

    assert %{"data" => %{"albums" => %{"edges" => albums}}} = response
    assert 2 = Enum.count(albums)
  end
end
