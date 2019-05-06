defmodule Dojinlist.Schemas.Storefront do
  use Ecto.Schema

  import Ecto.Changeset

  schema "storefronts" do
    field(:description, :string)
    field(:display_name, :string)
    field(:location, :string)
    field(:avatar_image, :string)
    field(:banner_image, :string)

    has_many(:albums, Dojinlist.Schemas.Album)
    has_one(:creator, Dojinlist.Schemas.User)

    timestamps(type: :utc_datetime)
  end

  def changeset(storefront, attrs) do
    storefront
    |> cast(attrs, [
      :description,
      :display_name,
      :location,
      :avatar_image,
      :banner_image
    ])
  end
end
