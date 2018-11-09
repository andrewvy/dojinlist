defmodule Dojinlist.Schemas.Event do
  use Ecto.Schema

  schema "events" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
  end
end
