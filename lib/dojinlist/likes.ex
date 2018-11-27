defmodule Dojinlist.Likes do
  alias Dojinlist.{
    Repo,
    Schemas
  }

  def like_rating(user_id, rating_id) do
    attrs = %{
      user_id: user_id,
      rating_id: rating_id
    }

    %Schemas.UserLikeRating{}
    |> Schemas.UserLikeRating.changeset(attrs)
    |> Repo.insert()
  end
end
