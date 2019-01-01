defmodule Transcoder do
  @moduledoc """
  Documentation for Transcoder.
  """

  def new_job(opts) do
    %Transcoder.Job{
      input_file: opts[:input_file],
      desired_format: opts[:desired_format]
    }
  end
end
