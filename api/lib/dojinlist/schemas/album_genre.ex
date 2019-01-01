defmodule Dojinlist.Schemas.AlbumGenre do
  use Ecto.Schema

  schema "albums_genres" do
    belongs_to :album, Dojinlist.Schemas.Album
    belongs_to :genre, Dojinlist.Schemas.Genre
  end
end
