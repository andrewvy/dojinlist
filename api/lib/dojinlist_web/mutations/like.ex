defmodule DojinlistWeb.Mutations.Like do
  use Absinthe.Schema.Notation

  alias Dojinlist.{
    Repo,
    Likes
  }

  object :like_mutations do
    field :like_rating, type: :rating_like do
      arg(:rating_id, non_null(:id))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, rating_id: :rating)

      resolve(&like_rating/2)
    end
  end

  def like_rating(%{rating_id: rating_id}, %{context: %{current_user: user}}) do
    case Likes.like_rating(user.id, rating_id) do
      {:ok, like} ->
        loaded_like = Repo.preload(like, [:user, :rating])
        {:ok, loaded_like}

      {:error, _} ->
        {:error, "Could not like rating"}
    end
  end
end
