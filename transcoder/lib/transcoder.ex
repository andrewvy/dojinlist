defmodule Transcoder do
  @moduledoc """
  Documentation for Transcoder.
  """

  def new_job(opts) do
    %Transcoder.Job{
      input_bucket: opts[:input_bucket],
      input_filepath: opts[:input_filepath],
      output_bucket: opts[:output_bucket],
      desired_format: opts[:desired_format]
    }
  end

  @doc """
  Execute a defined Transcoder.Job struct.
  """
  def execute(job) do
    with {:ok, source_file} <- Transcoder.S3.download(job.input_bucket, job.input_filepath),
         {:ok, transcoded_file} <- Transcoder.Job.execute(%{job | input_filepath: source_file}),
         source_extname = Path.extname(source_file),
         transcode_extname = Path.extname(transcoded_file),
         output_filepath = String.replace(job.input_filepath, source_extname, transcode_extname),
         {:ok, upload_response} <-
           Transcoder.S3.upload(job.output_bucket, transcoded_file, output_filepath) do
      {:ok, upload_response}
    else
      error -> error
    end
  end
end
