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
    |> validate_subdomain()
    |> validate_required([:creator_id, :subdomain])
    |> unique_constraint(:subdomain)
  end

  def validate_subdomain(changeset) do
    subdomain = get_change(changeset, :subdomain)

    if Dojinlist.Subdomain.blacklisted?(subdomain) do
      add_error(changeset, :subdomain, "Invalid subdomain")
    else
      changeset
    end
  end
end
