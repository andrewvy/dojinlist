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

  def download_track(album_uuid, track_uuid, encoding) do
    if valid_encoding?(encoding) do
      extname = get_extname(encoding)
      object_path = Path.join([album_uuid, encoding, "#{track_uuid}#{extname}"])
      {:ok, tmp_file} = Briefly.create(extname: extname)

      file =
        ExAws.S3.head_object(@bucket, object_path)
        |> ExAws.request!()

      response_headers = Map.new(file.headers)
      track_name = get_track_name(response_headers)
      track_index = get_track_index(response_headers)
      album_name = get_album_name(response_headers)

      download_name = "#{album_name} - #{track_index} - #{track_name}#{extname}"

      ExAws.S3.download_file(@bucket, object_path, tmp_file)
      |> ExAws.request()
      |> case do
        {:ok, _} ->
          {:ok, {download_name, tmp_file}}

        _ ->
          {:error, "Failed to download file from S3"}
      end
    else
      {:error, "Unsupported encoding"}
    end
  end

  def download_album(album_uuid, encoding) do
    {:ok, tmpdir} = Briefly.create(directory: true)

    download_object = fn object ->
      filepath = object.key
      filename = Path.basename(filepath)
      extname = Path.extname(filepath)
      tmp_file = Path.join([tmpdir, filename])

      response =
        ExAws.S3.head_object(@bucket, filepath)
        |> ExAws.request!()

      response_headers = Map.new(response.headers)

      track_name = get_track_name(response_headers)
      track_index = get_track_index(response_headers)
      album_name = get_album_name(response_headers)

      ExAws.S3.download_file(@bucket, filepath, tmp_file)
      |> ExAws.request!()

      {"#{album_name} - #{track_index} - #{track_name}#{extname}", tmp_file}
    end

    response =
      ExAws.S3.list_objects(@bucket, prefix: Path.join([album_uuid, encoding]))
      |> ExAws.request!()

    zipped_files =
      response.body.contents
      |> Task.async_stream(download_object, max_concurrency: 5, timeout: 120_000)
      |> Enum.map(fn {_status, result} -> result end)
      |> Enum.map(fn {download_filename, tmp_file} ->
        Zstream.entry(download_filename, File.stream!(tmp_file))
      end)

    first_file =
      response.body.contents
      |> List.first()

    file =
      ExAws.S3.head_object(@bucket, first_file.key)
      |> ExAws.request!()

    album_headers = Map.new(file.headers)
    album_name = get_album_name(album_headers)

    {"#{album_name}.zip", Zstream.zip(zipped_files)}
  end

  def get_album_name(headers) do
    Map.get(headers, "x-amz-meta-album-name", "")
  end

  def get_track_name(headers) do
    Map.get(headers, "x-amz-meta-track-name", "")
  end

  def get_track_index(headers) do
    Map.get(headers, "x-amz-meta-track-index", "1")
    |> Integer.parse()
    |> case do
      :error -> 1
      {index, _} -> index
    end
  end
end
