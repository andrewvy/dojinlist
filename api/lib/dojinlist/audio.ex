defmodule Dojinlist.Audio do
  alias Dojinlist.Audio.Stream

  @spec qualified_audio?([Stream.t()]) :: boolean
  def qualified_audio?(streams) when is_list(streams) do
    audio_stream =
      streams
      |> Enum.find(&(&1.codec_type === "audio"))

    if audio_stream do
      {sample_rate, _} = Integer.parse(audio_stream.sample_rate)

      audio_stream.codec_type === "audio" and
        audio_stream.sample_rate >= 44100
    else
      false
    end
  end

  @spec get_audio_stream([Stream.t()]) :: Stream.t() | nil
  def get_audio_stream(streams) when is_list(streams) do
    streams
    |> Enum.find(&(&1.codec_type === "audio"))
  end

  def probe(file) do
    opts = ["-v", "quiet", "-show_streams", "-print_format", "json", file.path]

    with {:ok, response} <- execute(opts),
         {:ok, json} <- Jason.decode(response) do
      streams =
        json
        |> Map.get("streams", [])
        |> Enum.map(&Stream.from_map/1)

      {:ok, streams}
    else
      error -> error
    end
  end

  defp execute(args) do
    case System.cmd(ffprobe_path(), args, stderr_to_stdout: true) do
      {body, 0} -> {:ok, body}
      error -> {:error, error}
    end
  end

  defp ffprobe_path() do
    System.find_executable("ffprobe")
  end
end
