defmodule DojinlistWeb.Resolvers.Rating do
  alias Dojinlist.Ratings

  def get_rating(_album, _params, %{context: %{current_user: nil}}) do
    {:ok, nil}
  end

  def get_rating(parent, _params, %{context: %{current_user: user}}) do
    {:ok, Ratings.get_album_rating(user, parent.node)}
  end

  def get_ratings_by_user(params, %{context: %{current_user: user}}) do
    Dojinlist.Schemas.UserRating
    |> Dojinlist.Schemas.UserRating.where_user_id(user.id)
    |> Dojinlist.Schemas.UserRating.preload()
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
