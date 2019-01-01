defmodule Dojinlist.Schemas.Artist do
  use Ecto.Schema

  import Ecto.Changeset

  schema "artists" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
  end

  def changeset(artist, attrs) do
    artist
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
