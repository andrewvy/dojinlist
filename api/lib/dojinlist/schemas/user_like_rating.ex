defmodule Dojinlist.Schemas.UserLikeRating do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users_likes_ratings" do
    belongs_to :user, Dojinlist.Schemas.User
    belongs_to :rating, Dojinlist.Schemas.UserRating

    timestamps(type: :utc_datetime)
  end

  def changeset(user_like, attrs) do
    user_like
    |> cast(attrs, [:user_id, :rating_id])
    |> validate_required([:user_id, :rating_id])
    |> unique_constraint(:user_id)
  end
end
