defmodule DojinlistWeb.Mutations.Download do
  use Absinthe.Schema.Notation

  object :download_mutations do
    field :generate_album_download_url, type: :download_response do
      arg(:download, non_null(:download_album_input))

      middleware(
        Absinthe.Relay.Node.ParseIDs,
        download: [
          album_id: :album
        ]
      )

      middleware(DojinlistWeb.Middlewares.Authorization)

      resolve(&generate_album_download_url/2)
    end

    field :generate_track_download_url, type: :download_response do
      arg(:download, non_null(:download_track_input))

      middleware(
        Absinthe.Relay.Node.ParseIDs,
        download: [
          track_id: :track
        ]
      )

      resolve(&generate_track_download_url/2)
    end
  end

  def generate_album_download_url(params, %{context: %{current_user: user}}) do
    album_id = params.download.album_id
    encoding = params.download.encoding

    case Dojinlist.Albums.get_album(album_id) do
      nil ->
        {:ok,
         %{
           errors: [
             %{
               error_code: "ALBUM_NOT_FOUND",
               error_message: "Album was not found"
             }
           ]
         }}

      album ->
        if Dojinlist.Downloader.able_to_download_album?(user, album) do
          url = Dojinlist.Downloader.download_album(album, encoding)

          {:ok,
           %{
             url: url
           }}
        else
          {:ok,
           %{
             errors: [
               %{
                 error_code: "ALBUM_NOT_PURCHASED",
                 error_message: "Album was not purchased"
               }
             ]
           }}
        end
    end
  end

  def generate_track_download_url(params, %{context: %{current_user: user}}) do
    track_id = params.download.track_id
    encoding = params.download.encoding

    case Dojinlist.Tracks.get_by_id(track_id) do
      nil ->
        {:ok,
         %{
           errors: [
             %{
               error_code: "TRACK_NOT_FOUND",
               error_message: "Track was not found"
             }
           ]
         }}

      track ->
        if Dojinlist.Downloader.able_to_download_track?(user, track, encoding) do
          url = Dojinlist.Downloader.download_track(track.album, track, encoding)

          {:ok,
           %{
             url: url
           }}
        else
          {:ok,
           %{
             errors: [
               %{
                 error_code: "TRACK_NOT_PURCHASED",
                 error_message: "Track was not purchased"
               }
             ]
           }}
        end
    end
  end
end
