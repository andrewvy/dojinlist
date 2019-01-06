defmodule Downloader.Router do
  use Plug.Router

  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(Plug.Parsers, parsers: [:urlencoded, :json], pass: ["text/*"], json_decoder: Jason)

  plug(:dispatch)

  @dojinlist_header "x-dojinlist-secret"

  get "/" do
    send_resp(conn, 200, "")
  end

  # ?enc - Requested encoding.
  get "/:album_uuid/:track_uuid/:hash" do
    request_headers = Map.new(conn.req_headers)
    encoding = conn.params["enc"]
    album_uuid = conn.params["album_uuid"]
    track_uuid = conn.params["track_uuid"]

    if valid_headers?(request_headers) && encoding && album_uuid && track_uuid do
      Downloader.download_track(album_uuid, track_uuid, encoding)
      |> case do
        {:ok, {download_name, tmp_file}} ->
          mimetype = Downloader.get_mimetype(encoding)

          conn
          |> put_resp_content_type(mimetype)
          |> put_resp_header("content-disposition", ~s[attachment; filename="#{download_name}"])
          |> set_cache_headers()
          |> Plug.Conn.send_file(200, tmp_file)

        {:error, _} ->
          send_resp(conn, 404, "Content not found")
      end
    else
      send_resp(conn, 404, "Content not found")
    end
  end

  get "/:album_uuid/:hash" do
    request_headers = Map.new(conn.req_headers)
    encoding = conn.params["enc"]
    album_uuid = conn.params["album_uuid"]

    if valid_headers?(request_headers) && encoding && album_uuid do
      {filename, zip_stream} = Downloader.download_album(album_uuid, encoding)

      conn =
        conn
        |> put_resp_content_type("application/octet-stream")
        |> put_resp_header("content-disposition", ~s[attachment; filename="#{filename}"])
        |> set_cache_headers()
        |> send_chunked(200)

      Enum.reduce_while(zip_stream, conn, fn chunk, conn ->
        case chunk(conn, chunk) do
          {:ok, conn} ->
            {:cont, conn}

          {:error, :closed} ->
            {:halt, conn}
        end
      end)
    else
      send_resp(conn, 404, "Content not found")
    end
  end

  match _ do
    send_resp(conn, 404, "")
  end

  defp set_cache_headers(conn) do
    conn
    |> put_resp_header("cache-control", "max-age=31536000")
  end

  if Mix.env() == :dev do
    defp valid_headers?(_), do: true
  else
    defp valid_headers?(request_headers) do
      case Map.get(request_headers, @dojinlist_header) do
        "" ->
          false

        nil ->
          false

        header_value ->
          header_value == System.get_env("DOJINLIST_SECRET_HEADER_VALUE")
      end
    end
  end
end
