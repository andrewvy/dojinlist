defmodule Dojinlist.Schemas.Album do
  use Ecto.Schema

  import Ecto.Query
  import Ecto.Changeset

  # @album_statuses [
  #   "pending",
  #   "submitted",
  #   "transcoded_failure",
  #   "completed"
  # ]

  schema "albums" do
    field(:uuid, Ecto.UUID, autogenerate: true)

    field(:title, :string)
    field(:description, :string)
    field(:cover_art, :string)
    field(:release_datetime, :utc_datetime)
    field(:price, Money.Ecto.Composite.Type, default: Money.new(:usd, 0))
    field(:slug, :string)
    field(:status, :string, default: "pending")
    field(:is_draft, :boolean, default: true)

    many_to_many(:artists, Dojinlist.Schemas.Artist, join_through: "albums_artists")
    many_to_many(:genres, Dojinlist.Schemas.Genre, join_through: "albums_genres")

    has_many(:ratings, Dojinlist.Schemas.UserRating)
    has_many(:tracks, Dojinlist.Schemas.Track)
    has_many(:external_links, Dojinlist.Schemas.ExternalAlbumLink, on_replace: :delete)

    belongs_to(:creator_user, Dojinlist.Schemas.User)
    belongs_to(:event, Dojinlist.Schemas.Event)
    belongs_to(:storefront, Dojinlist.Schemas.Storefront)

    timestamps(type: :utc_datetime)
  end

  def preload(query) do
    query
    |> preload([o], [:artists, :genres, :event, :ratings, :tracks])
  end

  def changeset(album, attrs) do
    album
    |> cast(attrs, [
      :cover_art,
      :creator_user_id,
      :description,
      :event_id,
      :is_draft,
      :price,
      :release_datetime,
      :slug,
      :status,
      :storefront_id,
      :title
    ])
    |> cast_assoc(:external_links, with: &Dojinlist.Schemas.ExternalAlbumLink.changeset/2)
    |> validate_required([:title, :storefront_id, :slug])
    |> validate_format(:slug, ~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/)
    |> unique_constraint(:slug, name: :albums_slug_storefront_id_index)
  end
end
