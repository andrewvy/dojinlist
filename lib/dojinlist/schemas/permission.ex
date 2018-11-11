defmodule Dojinlist.Schemas.Permission do
  use Ecto.Schema

  import Ecto.Changeset

  schema "permissions" do
    field :type, :string
  end

  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:type])
    |> validate_required([:type])
    |> unique_constraint(:type)
  end
end
