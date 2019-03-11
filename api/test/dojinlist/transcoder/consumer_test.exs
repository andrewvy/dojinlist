defmodule Dojinlist.Transcoder.ConsumerTest do
  use Dojinlist.DataCase, async: true

  alias Dojinlist.Transcoder.Consumer

  alias Dojinlist.{
    Albums,
    Hashid,
    Fixtures,
    Tracks
  }

  @payload %{
    "input_filepath" => "original.wav",
    "album_uuid" => "",
    "track_uuid" => "",
    "cover_image_filepath" => "cover.jpg",
    "title" => "Track #1",
    "artist" => "Test Artist",
    "date" => "2018-03-11",
    "comment" => "Comment",
    "album" => "Album Title",
    "track" => "1",
    "album_artist" => "Test Artist"
  }

  test "Normal payload marks track as completed" do
    {:ok, track} = Fixtures.track(%{transcoder_hash: "test"})

    track_uuid = Hashid.encode(track.id)

    assert track.status === "pending"

    body =
      @payload
      |> Map.merge(%{
        "track_uuid" => track_uuid,
        "hash" => "test"
      })
      |> Jason.encode!()

    %{
      body: body,
      message_id: "1234"
    }
    |> Consumer.process_message()

    track = Tracks.get_by_id(track.id)

    assert track.status === "completed"
  end

  test "Payload containing errors marks track as failed" do
    {:ok, track} = Fixtures.track(%{transcoder_hash: "test"})

    track_uuid = Hashid.encode(track.id)

    assert track.status === "pending"

    body =
      @payload
      |> Map.merge(%{
        "track_uuid" => track_uuid,
        "hash" => "test",
        "errors" => [
          "Could not transcode"
        ]
      })
      |> Jason.encode!()

    %{
      body: body,
      message_id: "1234"
    }
    |> Consumer.process_message()

    track = Tracks.get_by_id(track.id)

    assert track.status === "transcoded_failure"
  end

  test "Completing all tracks from an album marks it as completed" do
    {:ok, album} = Fixtures.album()
    {:ok, track_1} = Fixtures.track(%{album_id: album.id, transcoder_hash: "track_1"})
    {:ok, track_2} = Fixtures.track(%{album_id: album.id, transcoder_hash: "track_2"})

    assert album.status === "pending"

    track_uuid = Hashid.encode(track_1.id)

    body =
      @payload
      |> Map.merge(%{
        "track_uuid" => track_uuid,
        "hash" => "track_1"
      })
      |> Jason.encode!()

    %{
      body: body,
      message_id: "1234"
    }
    |> Consumer.process_message()

    album = Albums.get_album(album.id)
    assert album.status === "pending"

    track_uuid = Hashid.encode(track_2.id)

    body =
      @payload
      |> Map.merge(%{
        "track_uuid" => track_uuid,
        "hash" => "track_2"
      })
      |> Jason.encode!()

    %{
      body: body,
      message_id: "1234"
    }
    |> Consumer.process_message()

    album = Albums.get_album(album.id)
    assert album.status === "completed"
  end
end
