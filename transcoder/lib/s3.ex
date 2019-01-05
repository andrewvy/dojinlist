defmodule Transcoder.S3 do
  def download(bucket, input_filepath) do
    extname = Path.extname(input_filepath)

    {:ok, tmp_file} = Briefly.create(extname: extname)

    ExAws.S3.download_file(bucket, input_filepath, tmp_file)
    |> ExAws.request()
    |> case do
      {:ok, _} ->
        {:ok, tmp_file}

      {:error, _} ->
        File.rm(tmp_file)
        {:error, "Could not download file."}
    end
  end

  def upload(bucket, input_filepath, output_filepath, options) do
    input_filepath
    |> ExAws.S3.Upload.stream_file()
    |> ExAws.S3.upload(bucket, output_filepath, options)
    |> ExAws.request()
  end
end
