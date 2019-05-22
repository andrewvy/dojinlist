defmodule Dojinlist.Transcoder do
  @moduledoc """
  This module handles transcoding albums/tracks and managing the state
  of the transcoding process.

  A track has a status that determines it's current state in the transcoding process:

  @statuses [
    "pending",
    "submitted",
    "transcoded_failure",
    "completed"
  ]

  `pending` - Track has not been sent for transcoding.
  `submitted` - Track has been submitted for transcoding, but has not be processed yet.
  `transcoded_failure` - Track failed transcoding.
  `completed` - Track has been successfully transcoded.
  """

  alias Dojinlist.Schemas.Track

  alias Dojinlist.{
    Albums,
    Hashid,
    Storefront,
    Tracks,
    Repo
  }

  import Ecto.Query

  def submit_track_for_transcoding(%Track{} = track) do
    album = Albums.get_album(track.album_id)
    storefront = Storefront.by_id(album.storefront_id)

    job = create_transcoder_payload(storefront, album, track)

    job
    |> submit_transcoder_job()
    |> case do
      {:ok, _} ->
        if album.status !== "submitted" do
          Albums.update_album(album, %{
            status: "submitted"
          })
        end

        Tracks.update_track(track, %{
          status: "submitted",
          transcoder_hash: job[:hash]
        })

      _ ->
        Tracks.update_track(track, %{
          status: "transcoded_failure",
          transcoder_hash: job[:hash]
        })
    end
  end

  def mark_track_as_failed(%Track{} = track, payload) do
    album = Albums.get_album(track.album_id)

    if track.transcoder_hash == payload["hash"] do
      Tracks.update_track(track, %{
        status: "transcoded_failure"
      })

      Albums.update_album(album, %{
        status: "transcoded_failure"
      })
    else
      {:error, "Transcoder hash did not match, ignoring."}
    end
  end

  @doc """
  Given a track and SQS payload, marks the track `completed` if the hash matches the currently saved hash.

  If all tracks in an album are completed, the album is also marked as `completed`.
  """
  def mark_track_as_completed(%Track{} = track, payload) do
    if track.transcoder_hash == payload["hash"] do
      Tracks.update_track(track, %{
        status: "completed"
      })

      if all_tracks_are_completed?(track.album_id) do
        album = Albums.get_album(track.album_id)

        Albums.update_album(album, %{
          status: "completed"
        })
      end
    else
      {:error, "Transcoder hash did not match, ignoring."}
    end
  end

  defp create_transcoder_payload(storefront, album, track) do
    date = DateTime.to_date(album.updated_at)

    job =
      job_defaults()
      |> Map.merge(%{
        input_filepath: track.source_file,
        album_uuid: Hashid.encode(album.id),
        track_uuid: Hashid.encode(track.id),
        title: track.title,
        artist: storefront.display_name,
        date: Date.to_string(date),
        comment: "Purchased via Dojinlist",
        album: album.title,
        track: track.position,
        album_artist: storefront.display_name
      })

    job
    |> Map.put(:hash, compute_transcoder_hash(job))
  end

  defp job_defaults() do
    %{
      input_bucket: "dojinlist-raw-media",
      output_bucket: "dojinlist-transcoded-media"
    }
  end

  defp submit_transcoder_job(job) do
    json = Jason.encode!(job)

    ExAws.SQS.send_message("transcoder_jobs_successful", json)
    |> ExAws.request()
  end

  defp compute_transcoder_hash(job) do
    json = Jason.encode!(job)

    :crypto.hash(:sha256, json)
    |> Base.encode16()
  end

  defp all_tracks_are_completed?(album_id) do
    Track
    |> where([t], t.album_id == ^album_id)
    |> select([t], t.status)
    |> Repo.all()
    |> Enum.all?(&(&1 === "completed"))
  end
end
