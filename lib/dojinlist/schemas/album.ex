defmodule Dojinlist.Schemas.Album do
  use Ecto.Schema

  schema "albums" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
    field :sample_url, :string
    field :purchase_url, :string

    many_to_many :artists, Dojinlist.Schemas.Artist, join_through: "albums_artists"
    many_to_many :genres, Dojinlist.Schemas.Genre, join_through: "albums_genres"

    belongs_to :event, Dojinlist.Schemas.Event

    timestamps()
  end
end
