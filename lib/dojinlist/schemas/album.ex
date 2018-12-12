defmodule Dojinlist.Schemas.Album do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  schema "albums" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :romanized_title, :string
    field :japanese_title, :string
    field :sample_url, :string
    field :purchase_url, :string
    field :is_verified, :boolean, default: false
    field :cover_art, :string
    field :release_date, :date

    many_to_many :artists, Dojinlist.Schemas.Artist, join_through: "albums_artists"
    many_to_many :genres, Dojinlist.Schemas.Genre, join_through: "albums_genres"

    has_many :ratings, Dojinlist.Schemas.UserRating
    has_many :edit_history, Dojinlist.Schemas.AlbumEditHistory
    has_many :tracks, Dojinlist.Schemas.Track
    has_many :external_links, Dojinlist.Schemas.ExternalAlbumLink, on_replace: :delete

    belongs_to :creator_user, Dojinlist.Schemas.User
    belongs_to :event, Dojinlist.Schemas.Event

    timestamps(type: :utc_datetime)
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
    |> preload([o], [:artists, :genres, :event, :ratings, :tracks])
  end

  def changeset(album, attrs) do
    album
    |> cast(attrs, [
      :romanized_title,
      :japanese_title,
      :sample_url,
      :purchase_url,
      :event_id,
      :is_verified,
      :cover_art,
      :creator_user_id,
      :release_date
    ])
    |> cast_assoc(:external_links, with: &Dojinlist.Schemas.ExternalAlbumLink.changeset/2)
    |> validate_required([:japanese_title])
  end
end
