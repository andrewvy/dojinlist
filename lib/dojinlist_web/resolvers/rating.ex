defmodule DojinlistWeb.Resolvers.Rating do
  alias Dojinlist.Ratings

  def get_rating(_album, _params, %{context: %{current_user: nil}}) do
    {:ok, nil}
  end

  def get_rating(parent, _params, %{context: %{current_user: user}}) do
    {:ok, Ratings.get_album_rating(user, parent.node)}
  end
end
