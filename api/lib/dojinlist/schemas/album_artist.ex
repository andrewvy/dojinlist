defmodule Dojinlist.Schemas.AlbumArtist do
  use Ecto.Schema

  schema "albums_artists" do
    belongs_to :album, Dojinlist.Schemas.Album
    belongs_to :artist, Dojinlist.Schemas.Artist
  end
end
