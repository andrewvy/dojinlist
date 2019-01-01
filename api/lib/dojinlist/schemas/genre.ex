defmodule Dojinlist.Schemas.Genre do
  use Ecto.Schema

  import Ecto.Changeset

  schema "genres" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
  end

  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
