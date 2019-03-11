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
    :pending,
    :submitted,
    :transcoded_failure,
    :transcoded_success
  ]
end
