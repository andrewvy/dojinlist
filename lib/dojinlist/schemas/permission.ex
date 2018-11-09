defmodule Dojinlist.Schemas.Permission do
  use Ecto.Schema

  schema "permissions" do
    field :type, :string
  end
end
