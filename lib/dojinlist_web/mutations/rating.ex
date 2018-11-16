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
end
