defmodule Transcoder do
  @moduledoc """
  Documentation for Transcoder.
  """

  @doc """
  Execute a defined Transcoder.Job struct.
  """
  def execute(job) do
    start_ms = System.monotonic_time(:milliseconds)

    with {:ok, source_file} <- Transcoder.S3.download(job.input_bucket, job.input_filepath),
         {:ok, transcoded_file} <- Transcoder.Job.transcode(%{job | input_filepath: source_file}),
         source_extname = Path.extname(source_file),
         transcode_extname = Path.extname(transcoded_file),
         output_filepath = String.replace(job.input_filepath, source_extname, transcode_extname),
         {:ok, _} <- Transcoder.S3.upload(job.output_bucket, transcoded_file, output_filepath) do
      Briefly.cleanup()

      end_ms = System.monotonic_time(:milliseconds)
      diff = end_ms - start_ms

      successful_job = %{
        job
        | output_filepath: output_filepath,
          elapsed_time: diff
      }

      {:ok, successful_job}
    else
      error -> error
    end
  end
end
