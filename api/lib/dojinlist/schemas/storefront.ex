defmodule Dojinlist.Schemas.Storefront do
  use Ecto.Schema

  import Ecto.Changeset

  schema "storefronts" do
    field(:description, :string)
    field(:display_name, :string)
    field(:location, :string)
    field(:slug, :string)
    field(:avatar_image, :string)
    field(:banner_image, :string)

    belongs_to(:creator, Dojinlist.Schemas.User)
    has_many(:albums, Dojinlist.Schemas.Album)

    timestamps(type: :utc_datetime)
  end

  def changeset(storefront, attrs) do
    storefront
    |> cast(attrs, [
      :creator_id,
      :description,
      :display_name,
      :location,
      :avatar_image,
      :banner_image,
      :slug
    ])
    |> validate_slug()
    |> validate_required([:creator_id, :slug])
    |> unique_constraint(:slug)
  end

  def validate_slug(changeset) do
    slug = get_change(changeset, :slug)

    if Dojinlist.Blacklist.blacklisted?(slug) do
      add_error(changeset, :slug, "Invalid slug")
    else
      changeset
    end
  end
end
