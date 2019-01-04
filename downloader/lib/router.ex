defmodule Downloader.Router do
  use Plug.Router

  plug(Plug.Logger, log: :debug)

  plug(:match)

  plug(Plug.Parsers, parsers: [:urlencoded, :json], pass: ["text/*"], json_decoder: Jason)

  plug(:dispatch)

  # ?enc - Requested encoding.
  get "/:album_uuid/:track_uuid/:hash" do
    encoding = conn.params["enc"]
    album_uuid = conn.params["album_uuid"]
    track_uuid = conn.params["track_uuid"]

    if encoding && album_uuid && track_uuid do
      Downloader.download(album_uuid, track_uuid, encoding)
      |> case do
        {:ok, tmp_file} ->
          mimetype = Downloader.get_mimetype(encoding)
          download_name = conn.params["as"] || track_uuid <> Downloader.get_extname(encoding)

          conn
          |> put_resp_content_type(mimetype)
          |> put_resp_header("content-disposition", ~s[attachment; filename="#{download_name}"])
          |> Plug.Conn.send_file(200, tmp_file)

        {:error, _} ->
          send_resp(conn, 404, "Content not found")
      end
    else
      send_resp(conn, 404, "Content not found")
    end
  end

  match _ do
    send_resp(conn, 404, "")
  end
end
