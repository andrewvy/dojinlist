defmodule Dojinlist.Schemas.Artist do
  use Ecto.Schema

  schema "artists" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
  end
end
