defmodule Dojinlist.Schemas.UserRating do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users_ratings" do
    belongs_to :user, Dojinlist.Schemas.User
    belongs_to :album, Dojinlist.Schemas.Album

    field :rating, :integer
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:user_id, :album_id, :rating, :description])
    |> validate_required([:user_id, :album_id])
    |> unique_constraint(:user_id)
  end
end
