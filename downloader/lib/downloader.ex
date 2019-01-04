defmodule Downloader do
  @moduledoc """
  Documentation for Downloader.
  """

  @bucket "dojinlist-transcoded-media"

  @encoding_extname %{
    "mp3-320" => ".mp3",
    "mp3-128" => ".mp3",
    "mp3-v0" => ".mp3",
    "flac" => ".flac",
    "aiff" => ".aiff",
    "wav" => ".wav"
  }

  @encoding_mimetype %{
    "mp3-320" => "audio/mpeg",
    "mp3-128" => "audio/mpeg",
    "mp3-v0" => "audio/mpeg",
    "flac" => "audio/flac",
    "aiff" => "audio/aiff",
    "wav" => "audio/wav"
  }

  def valid_encoding?(encoding) do
    Map.keys(@encoding_extname)
    |> Enum.member?(encoding)
  end

  def get_extname(encoding) do
    @encoding_extname[encoding]
  end

  def get_mimetype(encoding) do
    @encoding_mimetype[encoding]
  end

  def download(album_uuid, track_uuid, encoding) do
    if valid_encoding?(encoding) do
      extname = get_extname(encoding)
      object_path = Path.join([album_uuid, encoding, "#{track_uuid}#{extname}"])
      {:ok, tmp_file} = Briefly.create(extname: extname)

      ExAws.S3.download_file(@bucket, object_path, tmp_file)
      |> ExAws.request()
      |> case do
        {:ok, _} ->
          {:ok, tmp_file}

        _ ->
          {:error, "Failed to download file from S3"}
      end
    else
      {:error, "Unsupported encoding"}
    end
  end
end
