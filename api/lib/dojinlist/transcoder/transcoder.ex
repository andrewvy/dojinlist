defmodule Dojinlist.Transcoder do
  @moduledoc """
  This module handles transcoding albums/tracks and managing the state
  of the transcoding process.

  A track has a status that determines it's current state in the transcoding process:

  `pending` - Track has not been sent for transcoding.
  `submitted` - Track has been submitted for transcoding, but has not be processed yet.
  `transcoded_failure` - Track failed transcoding.
  `transcoded_success` - Track has been successfully transcoded.
  """

  @statuses [
    "pending",
    "submitted",
    "transcoded_failure",
    "transcoded_success"
  ]

  alias Dojinlist.Schemas.Track

  alias Dojinlist.{
    Albums,
    Hashid,
    Storefront
  }

  def submit_track_for_transcoding(%Track{status: status} = track)
      when status in ["pending", "transcoded_failure", "transcoded_success"] do
    album = Albums.get_album(track.album_id)
    storefront = Storefront.by_id(album.storefront_id)
  end

  def submit_track_for_transcoding(_), do: {:error, "Track is not submittable for transcoding"}

  defp create_transcoder_payload(storefront, album, track) do
    input_bucket = "dojinlist-raw-media"
    output_bucket = "dojinlist-transcoded-media"
    date = DateTime.to_date(album.updated_at)

    %{
      input_bucket: input_bucket,
      input_filepath: track.source_file,
      output_bucket: output_bucket,
      album_uuid: Hashid.encode(album.id),
      track_uuid: Hashid.encode(track.id),
      cover_image_filepath: album.cover_art,
      title: track.title,
      artist: storefront.display_name,
      date: Date.to_string(date),
      comment: "Purchased via Dojinlist",
      album: album.title,
      track: track.index,
      album_artist: storefront.display_name
    }
  end

  defp submit_transcoder_job(job) do
  end
end
