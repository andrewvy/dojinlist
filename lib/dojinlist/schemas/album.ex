defmodule Dojinlist.Schemas.Album do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  schema "albums" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
    field :sample_url, :string
    field :purchase_url, :string
    field :is_verified, :boolean, default: false

    many_to_many :artists, Dojinlist.Schemas.Artist, join_through: "albums_artists"
    many_to_many :genres, Dojinlist.Schemas.Genre, join_through: "albums_genres"

    has_many :ratings, Dojinlist.Schemas.UserRating

    belongs_to :event, Dojinlist.Schemas.Event

    timestamps()
  end

  def where_verified?(query) do
    query
    |> where([o], o.is_verified == true)
  end

  def where_unverified?(query) do
    query
    |> where([o], o.is_verified == false)
  end

  def preload(query) do
    query
    |> preload([o], [:artists, :genres])
  end

  def changeset(album, attrs) do
    album
    |> cast(attrs, [:name, :sample_url, :purchase_url, :is_verified])
    |> validate_required([:name])
  end
end
