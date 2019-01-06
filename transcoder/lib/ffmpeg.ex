defmodule Transcoder.FFmpeg do
  def execute(args) do
    case System.cmd(ffmpeg_path(), args, stderr_to_stdout: true) do
      {_, 0} -> :ok
      error -> {:error, error}
    end
  end

  def ffmpeg_path() do
    System.find_executable("ffmpeg")
  end
end
