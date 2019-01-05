defmodule Transcoder do
  @moduledoc """
  Documentation for Transcoder.
  """

  @doc """
  Execute a defined Transcoder.Job struct.
  """
  def execute(job) do
    start_ms = System.monotonic_time(:milliseconds)

    case Transcoder.Job.transcode(job) do
      {:ok, job} ->
        end_ms = System.monotonic_time(:milliseconds)
        diff = end_ms - start_ms

        successful_job = %{
          job
          | elapsed_time: diff
        }

        Briefly.cleanup()

        {:ok, successful_job}

      error ->
        Briefly.cleanup()

        error
    end
  end
end
