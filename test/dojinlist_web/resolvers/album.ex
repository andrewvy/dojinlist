defmodule DojinlistWeb.Resolvers.AlbumTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  @query """
    query SearchAlbums($eventId: ID) {
      albums(first: 25, event_id: $eventId) {
        edges {
          node {
            id
            name
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
    {:ok, _} = Fixtures.album(%{is_verified: true})
    {:ok, _} = Fixtures.album(%{event_id: event.id, is_verified: true})

    event_id = Absinthe.Relay.Node.to_global_id(:event, event.id, DojinlistWeb.Schema)

    variables = %{
      eventId: event_id
    }

    response =
      build_conn()
      |> Fixtures.create_and_login_as_admin()
      |> post(@endpoint, %{query: @query, variables: variables})
      |> json_response(200)

    assert %{"data" => %{"albums" => %{"edges" => [edge]}}} = response
    assert %{"node" => %{"event" => %{"id" => ^event_id}}} = edge
  end
end
