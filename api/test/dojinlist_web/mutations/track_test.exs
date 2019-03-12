defmodule DojinlistWeb.Mutations.TrackTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.{
    Fixtures,
    Tracks
  }

  test "Can create a track" do
    query = """
    mutation CreateTrack($albumId: ID!, $track: TrackInput!) {
      createTrack(albumId: $albumId, track: $track) {
        id
      }
    }
    """

    {:ok, user} = Fixtures.user()
    {:ok, album} = Fixtures.album()

    album_id = Absinthe.Relay.Node.to_global_id(:album, album.id, DojinlistWeb.Schema)

    variables = %{
      albumId: album_id,
      track: %{
        title: "Test",
        position: 1
      }
    }

    response =
      build_conn()
      |> Fixtures.login_as(user)
      |> execute_graphql(query, variables)

    assert %{"data" => %{"createTrack" => %{"id" => track_id}}} = response

    assert {:ok, track_id} = Absinthe.Relay.Node.from_global_id(track_id, DojinlistWeb.Schema)
    assert track = Tracks.get_by_id(track_id.id)
    assert track.album_id === album.id
    assert track.title === "Test"
  end
end
