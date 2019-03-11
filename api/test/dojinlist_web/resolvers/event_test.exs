defmodule DojinlistWeb.Resolvers.EventTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Fixtures

  @query """
    query SearchEvents($search: String!) {
      events(first: 25, search: $search) {
        edges {
          node {
            id
            name
          }
        }
      }
    }
  """

  test "Can search for an album by event_id" do
    {:ok, _} = Fixtures.event(%{name: "Test Alpha"})
    {:ok, _} = Fixtures.event(%{name: "Test Beta"})
    {:ok, _} = Fixtures.event(%{name: "Test Gamma"})

    conn =
      build_conn()
      |> Fixtures.create_and_login_as_admin()

    response =
      conn
      |> execute_graphql(@query, %{search: "Test"})

    assert %{"data" => %{"events" => %{"edges" => events}}} = response
    assert 3 == Enum.count(events)

    response =
      conn
      |> execute_graphql(@query, %{search: "Alpha"})

    assert %{"data" => %{"events" => %{"edges" => [event]}}} = response
    assert %{"node" => %{"name" => "Test Alpha"}} = event
  end
end
