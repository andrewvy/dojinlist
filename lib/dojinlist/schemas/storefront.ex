defmodule Dojinlist.Schemas.Storefront do
  use Ecto.Schema

  import Ecto.Changeset

  schema "storefronts" do
    field :subdomain, :string

    belongs_to :creator, Dojinlist.Schemas.User
    has_many :albums, Dojinlist.Schemas.Album

    timestamps(type: :utc_datetime)
  end

  def changeset(storefront, attrs) do
    storefront
    |> cast(attrs, [
      :creator_id,
      :subdomain
    ])
    |> validate_required([:creator_id, :subdomain])
    |> unique_constraint(:subdomain)
  end
end
