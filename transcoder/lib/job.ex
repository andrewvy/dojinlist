defmodule Transcoder.Job do
  defstruct [
    :input_bucket,
    :input_filepath,
    :output_bucket,
    :elapsed_time,
    :cover_image_filepath,

    # Meta
    :album_uuid,
    :track_uuid,

    # Tags
    :title,
    :artist,
    :date,
    :comment,
    :album,
    :track,
    :album_artist

    :hash
  ]

  @doc """
  This expects params with:

  input_bucket:
  output_bucket:
  input_filepath:
  album_uuid:
  track_uuid:
  """
  def new(params) do
    job = %{
      input_bucket: params["input_bucket"],
      input_filepath: params["input_filepath"],
      output_bucket: params["output_bucket"],
      album_uuid: params["album_uuid"],
      track_uuid: params["track_uuid"],
      cover_image_filepath: params["cover_image_filepath"],
      title: params["title"],
      artist: params["artist"],
      date: params["date"],
      comment: params["comment"],
      album: params["album"],
      track: params["track"],
      album_artist: params["album_artist"],
      hash: params["hash"]
    }

    if Vex.valid?(job,
         input_bucket: [presence: true],
         input_filepath: [presence: true],
         output_bucket: [presence: true],
         album_uuid: [presence: true],
         track_uuid: [presence: true],
         title: [presence: true],
         track: [presence: true],
         artist: [presence: true],
         album_artist: [presence: true],
         hash: [presence: true]
       ) do
      {:ok, struct(__MODULE__, job)}
    else
      {:error, "Invalid job format."}
    end
  end

  def transcode(job) do
    album_uuid = job.album_uuid
    track_uuid = job.track_uuid

    cover_image =
      if job.cover_image_filepath do
        {:ok, cover_image_filepath} =
          Transcoder.S3.download(job.output_bucket, job.cover_image_filepath)

        cover_image_filepath
      else
        nil
      end

    results =
      Transcoder.S3.download(job.input_bucket, job.input_filepath)
      |> case do
        {:ok, source_file} ->
          Transcoder.FFmpeg.presets()
          |> Task.async_stream(
            fn {format, preset} ->
              {:ok, tmp_file} = Briefly.create(extname: preset.ext)
              s3_output_path = Path.join([album_uuid, format, "#{track_uuid}#{preset.ext}"])

              Transcoder.FFmpeg.transcode(job, preset, source_file, tmp_file, cover_image)
              |> case do
                :ok ->
                  Transcoder.S3.upload(job.output_bucket, tmp_file, s3_output_path,
                    meta: [
                      {"track-name", job.title || ""},
                      {"track-index", job.track || "1"},
                      {"album-name", job.album || ""},
                      {"album-artist", job.album_artist || ""}
                    ]
                  )
                  |> case do
                    {:ok, _} -> {:ok, job}
                    _ -> {:error, "Could not upload to S3."}
                  end

                _ ->
                  {:error, "Could not transcode into format: #{format}"}
              end
            end,
            timeout: 120_000
          )
          |> Enum.to_list()

        _ ->
          [{:error, "Could not download source file."}]
      end

    if Enum.all?(results, fn {status, _} -> status == :ok end) do
      {:ok, job}
    else
      Enum.find(results, fn {status, _} -> status == :error end)
    end
  end
end
