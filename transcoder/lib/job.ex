defmodule Transcoder.Job do
  use FFmpex.Options

  defstruct [
    :input_bucket,
    :output_bucket,
    :input_filepath,
    :desired_format,

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

  def formats, do: @formats |> Map.keys()

  def preset_for_format(format) do
    Map.get(@formats, format)
  end

  def transcode(%__MODULE__{desired_format: format} = job) do
    preset = preset_for_format(format)

    if preset do
      transcode_ffmpeg(job, preset)
    else
      {:error, "Could not find preset for format #{format}"}
    end
  end

  def transcode(_), do: {:error, "Desired format not recognized."}

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
