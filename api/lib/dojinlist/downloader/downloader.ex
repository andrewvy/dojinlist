defmodule Dojinlist.Downloader do
  alias Dojinlist.Repo

  alias Dojinlist.Schemas.{
    PurchasedAlbum,
    User
  }

  import Ecto.Query

  @default_expiry_time 60

  def able_to_download_album?(%User{} = user, album) do
    purchased_album =
      PurchasedAlbum
      |> where([a], a.album_id == ^album.id)
      |> where([a], a.user_id == ^user.id)
      |> Repo.one()

    purchased_album !== nil
  end

  def able_to_download_album?(user_email, album) do
    purchased_album =
      PurchasedAlbum
      |> where([a], a.album_id == ^album.id)
      |> where([a], a.user_email == ^user_email)
      |> Repo.one()

    purchased_album !== nil
  end

  def download_album(album_uuid, encoding) do
    url = "https://bits.dojinlist.co/#{album_uuid}/a?enc=#{encoding}"
    params = parameters(url)

    url <> "&" <> params
  end

  def download_track(album_uuid, track_uuid, encoding) do
    url = "https://bits.dojinlist.co/#{album_uuid}/#{track_uuid}/a?enc=#{encoding}"
    params = parameters(url)

    url <> "&" <> params
  end

  def parameters(url) do
    expires = (DateTime.utc_now() |> DateTime.to_unix()) + @default_expiry_time

    sanitized_signature =
      url
      |> generate_signature(expires)

    [
      "Expires=#{expires}",
      "Signature=#{sanitized_signature}",
      "Key-Pair-Id=APKAIHB4AU6DSTJ3K2GA"
    ]
    |> Enum.join("&")
  end

  def generate_signature(url, expires) do
    """
    {
       "Statement":[
          {
             "Resource":"#{url}",
             "Condition":{
                "DateLessThan":{
                   "AWS:EpochTime":#{expires}
                }
             }
          }
       ]
    }
    """
    |> String.replace(~r/\s/, "")
    |> :public_key.sign(:sha, private_key())
    |> Base.encode64()
    |> String.replace("+", "-")
    |> String.replace("=", "_")
    |> String.replace("/", "~")
  end

  def private_key() do
    priv_key_path = Application.app_dir(:dojinlist, "priv/dojinlist.pem")

    File.read!(priv_key_path)
    |> :public_key.pem_decode()
    |> hd()
    |> :public_key.pem_entry_decode()
  end
end
