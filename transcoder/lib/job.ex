defmodule Transcoder.Job do
  use FFmpex.Options

  defstruct [
    :input_bucket,
    :input_filepath,
    :output_bucket,
    :output_filepath,
    :input_file,
    :output_file,
    :desired_format
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

  def format_to_ffmpeg(%__MODULE__{desired_format: format} = job) do
    preset = preset_for_format(format)

    if preset do
      transcoded_filepath = Path.rootname(job.input_file) <> preset.ext

      base_command =
        FFmpex.new_command()
        |> FFmpex.add_global_option(option_y())
        |> FFmpex.add_input_file(job.input_file)
        |> FFmpex.add_output_file(transcoded_filepath)

      Enum.reduce(preset.file_options, base_command, fn file_option, acc ->
        acc
        |> FFmpex.add_file_option(file_option)
      end)
      |> FFmpex.prepare()
    else
      {:error, "Could not find preset for format #{format}"}
    end
  end

  def format_to_ffmpeg(_), do: {:error, "Desired format not recognized."}
end
