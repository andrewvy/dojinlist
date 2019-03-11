defmodule Dojinlist.Transcoder.ConsumerTest do
  use Dojinlist.DataCase, async: true

  alias Dojinlist.Transcoder.Consumer

  alias Dojinlist.{
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
end
