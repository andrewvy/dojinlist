defmodule DojinlistWeb.Mutations.Download do
  use Absinthe.Schema.Notation

  object :download_mutations do
    field :generate_album_download_url, type: :download_response do
      arg(:download, non_null(:download_input))

      middleware(
        Absinthe.Relay.Node.ParseIDs,
        download: [
          album_id: :album
        ]
      )

      middleware(DojinlistWeb.Middlewares.Authorization)

      resolve(&generate_album_download_url/2)
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
end
