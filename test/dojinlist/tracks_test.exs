defmodule Dojinlist.TracksTest do
  use Dojinlist.DataCase

  alias Dojinlist.{
    Tracks,
    Fixtures
  }

  test "Can create a track" do
    {:ok, album} = Fixtures.album()

    {:ok, track} =
      Tracks.create_track(album.id, %{
        title: "The Beginning",
        kana_title: "The Beginning",
        play_length: 126
      })

    assert album.id == track.album_id
  end
end
