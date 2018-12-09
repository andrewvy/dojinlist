defmodule Dojinlist.Schemas.UserRating do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

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
    |> validate_inclusion(:rating, 0..10)
    |> unique_constraint(:user_id)
  end

  def where_user_id(query, user_id) do
    query
    |> where([o], o.user_id == ^user_id)
  end

  def preload(query) do
    query
    |> preload([o], [:album])
  end
end
