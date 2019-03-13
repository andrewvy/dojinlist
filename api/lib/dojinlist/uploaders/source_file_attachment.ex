defmodule Dojinlist.SourceFileAttachment do
  use Arc.Definition

  @extension_whitelist ~w(.wav .aiff .flac)
  @versions [:original]

  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()

    Enum.member?(@extension_whitelist, file_extension) && valid_audio_stream?(file.path)
  end

  def filename(version, {file, _}) do
    file_name = Path.basename(file.file_name, Path.extname(file.file_name))

    "#{version}_#{file_name}"
  end

  def s3_object_headers(_version, {file, _scope}) do
    [content_type: MIME.from_path(file.file_name)]
  end

  def bucket, do: "dojinlist-raw-media"

  def valid_audio_stream?(file_path) do
    {output, status} =
      System.cmd("ffprobe", [
        "-v",
        "quiet",
        "-print_format",
        "json",
        "-show_format",
        "-show_streams",
        file_path
      ])

    if status == 0 do
      output
      |> String.trim()
      |> Jason.decode()
      |> case do
        {:ok, json} ->
          json
          |> Map.get("streams", [])
          |> only_audio_streams()
          |> valid_sample_rates?()

        _ ->
          false
      end
    else
      false
    end
  end

  defp only_audio_streams(streams) do
    streams
    |> Enum.filter(fn stream -> stream["codec_type"] === "audio" end)
  end

  defp valid_sample_rates?(streams) do
    streams
    |> Enum.any?(fn stream ->
      valid_sample_rate?(stream)
    end)
  end

  defp valid_sample_rate?(stream) do
    stream["sample_rate"]
    |> Integer.parse()
    |> case do
      :error ->
        false

      {sample_rate, _} ->
        sample_rate >= 44100
    end
  end
end
