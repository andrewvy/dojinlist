defmodule DojinlistWeb.Mutations.Rating do
  use Absinthe.Schema.Notation

  alias Dojinlist.{
    Albums,
    Ratings
  }

  object :rating_mutations do
    field :create_rating, type: :rating do
      arg(:album_id, non_null(:id))
      arg(:rating, :integer)
      arg(:description, :string)

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)

      resolve(&create_rating/2)
    end

    field :delete_rating, type: :rating do
      arg(:id, non_null(:id))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, id: :rating)

      resolve(&delete_rating/2)
    end
  end

  def create_rating(%{album_id: album_id} = attrs, %{context: %{current_user: user}}) do
    case Albums.get_album(album_id) do
      nil ->
        # @TODO(vy): i18n
        {:error, "Could not find an album with that id"}

      album ->
        case Ratings.create_rating(user, album, attrs) do
          {:ok, rating} ->
            {:ok, rating}

          {:error, _changeset} ->
            # @TODO(vy): i18n
            {:error, "Could not create rating"}
        end
    end
  end

  def delete_rating(%{id: id}, %{context: %{current_user: user}}) do
    case Ratings.get_by_id(id) do
      nil ->
        {:error, "Could not find a rating with that id"}

      rating ->
        if rating.user_id == user.id do
          Ratings.delete_rating(rating)
        else
          {:error, "Could not find a rating with that id"}
        end
    end
  end
end
