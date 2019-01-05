defmodule Transcoder.Job do
  use FFmpex.Options

  defstruct [
    :input_bucket,
    :input_filepath,
    :output_bucket,
    :elapsed_time,

    # Meta
    :album_uuid,
    :track_uuid,

    # Tags
    :title,
    :artist,
    :date,
    :comment,
    :album,
    :track
  ]

  @formats %{
    "mp3-v0" => %{
      ext: ".mp3",
      file_options: [
        option_q("0"),
        option_ac("2")
      ]
    },
    "mp3-320" => %{
      ext: ".mp3",
      file_options: [
        option_b("320k"),
        option_ac("2")
      ]
    },
    "mp3-128" => %{
      ext: ".mp3",
      file_options: [
        option_b("128k"),
        option_ac("2")
      ]
    },
    "flac" => %{
      ext: ".flac",
      file_options: [
        option_ac("2")
      ]
    },
    "aiff" => %{
      ext: ".aiff",
      file_options: [
        option_ac("2")
      ]
    }
  }

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
      title: params["title"],
      artist: params["artist"],
      date: params["date"],
      comment: params["comment"],
      album: params["album"],
      track: params["track"]
    }

    if Vex.valid?(job,
         input_bucket: [presence: true],
         input_filepath: [presence: true],
         output_bucket: [presence: true],
         album_uuid: [presence: true],
         track_uuid: [presence: true],
         title: [presence: true],
         track: [presence: true]
       ) do
      {:ok, struct(__MODULE__, job)}
    else
      {:error, "Invalid job format."}
    end
  end

  def formats, do: @formats |> Map.keys()

  def preset_for_format(format) do
    Map.get(@formats, format)
  end

  def transcode(job) do
    album_uuid = job.album_uuid
    track_uuid = job.track_uuid

    results =
      Transcoder.S3.download(job.input_bucket, job.input_filepath)
      |> case do
        {:ok, source_file} ->
          @formats
          |> Enum.map(fn {format, preset} ->
            IO.puts("format=#{format} source_file=#{source_file}")

            with {:ok, transcoded_file} <-
                   transcode_ffmpeg(%{job | input_filepath: source_file}, preset),
                 transcode_extname = Path.extname(transcoded_file),
                 output_filepath =
                   Path.join([album_uuid, format, "#{track_uuid}#{transcode_extname}"]),
                 {:ok, _} <-
                   Transcoder.S3.upload(job.output_bucket, transcoded_file, output_filepath,
                     meta: [
                       {"track-name", job.title || ""},
                       {"track-index", job.track || "1"},
                       {"album-name", job.album || ""},
                       {"album-artist", job.album_artist || ""}
                     ]
                   ) do
              {:ok, job}
            else
              _ ->
                {:error, "Could not transcode into format: #{format}"}
            end
          end)

        _ ->
          {:error, "Could not download source file."}
      end

    if Enum.all?(results, fn {status, _} -> status == :ok end) do
      {:ok, job}
    else
      Enum.find(results, fn {status, _} -> status == :error end)
    end
  end

  def transcode_ffmpeg(job, preset) do
    {:ok, output_file} = Briefly.create(extname: preset.ext)

    base_command =
      FFmpex.new_command()
      |> FFmpex.add_global_option(option_y())
      |> FFmpex.add_input_file(job.input_filepath)
      |> FFmpex.add_output_file(output_file)

    command =
      Enum.reduce(preset.file_options, base_command, fn file_option, acc ->
        acc
        |> FFmpex.add_file_option(file_option)
      end)
      |> tags(job)

    command
    |> FFmpex.execute()
    |> case do
      :ok -> {:ok, output_file}
      {:error, _} -> {:error, "Error while transcoding file."}
    end
  end

  def tags(command, job) do
    command
    |> FFmpex.add_file_option(option_metadata("title=#{job.title}"))
    |> FFmpex.add_file_option(option_metadata("album=#{job.album}"))
    |> FFmpex.add_file_option(option_metadata("artist=#{job.artist}"))
    |> FFmpex.add_file_option(option_metadata("album_artist=#{job.artist}"))
    |> FFmpex.add_file_option(option_metadata("track=#{job.track}"))
    |> FFmpex.add_file_option(option_metadata("comment=#{job.comment}"))
  end
end
