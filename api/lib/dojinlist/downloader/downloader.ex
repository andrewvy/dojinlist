defmodule Dojinlist.Downloader do
  alias Dojinlist.Repo

  alias Dojinlist.Schemas.{
    PurchasedAlbum,
    User
  }

  import Ecto.Query

  @default_expiry_time 60

  @whitelisted_encodings [
    "mp3-128"
  ]

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

  def able_to_download_track?(user, track, encoding \\ nil)

  def able_to_download_track?(nil, _track, encoding) do
    Enum.member?(@whitelisted_encodings, encoding)
  end

  def able_to_download_track?(%User{} = user, track, encoding) do
    purchased_album =
      PurchasedAlbum
      |> where([a], a.album_id == ^track.album_id)
      |> where([a], a.user_id == ^user.id)
      |> Repo.one()

    purchased_album !== nil || Enum.member?(@whitelisted_encodings, encoding)
  end

  def able_to_download_track?(user_email, track, encoding) do
    purchased_album =
      PurchasedAlbum
      |> where([a], a.album_id == ^track.album_id)
      |> where([a], a.user_email == ^user_email)
      |> Repo.one()

    purchased_album !== nil || Enum.member?(@whitelisted_encodings, encoding)
  end

  def download_album(album, encoding) do
    album_id = Dojinlist.Hashid.encode(album.id)
    url = "https://bits.dojinlist.co/#{album_id}/#{hash_album(album)}?enc=#{encoding}"

    params = parameters(url)

    url <> "&" <> params
  end

  def download_track(album, track, encoding) do
    album_id = Dojinlist.Hashid.encode(album.id)
    track_id = Dojinlist.Hashid.encode(track.id)
    url = "https://bits.dojinlist.co/#{album_id}/#{track_id}/#{hash_track(track)}?enc=#{encoding}"
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

  def hash_album(album) do
    dependent_parts = [
      album.title,
      album.cover_art
    ]

    track_parts = Enum.map(album.tracks, & &1.title)

    (dependent_parts ++ track_parts)
    |> hash()
  end

  def hash_track(track) do
    [
      track.title
    ]
    |> hash()
  end

  def hash(parts) do
    sha = :crypto.hash_init(:sha256)

    sha =
      parts
      |> Enum.reject(&(&1 == nil))
      |> Enum.reduce(sha, fn part, acc ->
        :crypto.hash_update(acc, part)
      end)

    sha_binary = :crypto.hash_final(sha)

    sha_binary
    |> Base.encode16()
    |> String.downcase()
  end
end
