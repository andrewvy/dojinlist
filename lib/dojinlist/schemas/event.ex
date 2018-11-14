defmodule Dojinlist.Schemas.Event do
  use Ecto.Schema

  import Ecto.Changeset

  schema "events" do
    field :uuid, Ecto.UUID, autogenerate: true
    field :name, :string
    field :start_date, :date
    field :end_date, :date

    has_many :albums, Dojinlist.Schemas.Album
  end

  def changeset(event, attrs) do
    event
    |> cast(attrs, [:name, :start_date, :end_date])
    |> unique_constraint(:name)
  end
end
