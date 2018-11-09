defmodule Dojinlist.Schemas.Genre do
  use Ecto.Schema

  schema "genres" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
  end
end
