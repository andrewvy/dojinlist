defmodule DojinlistWeb.Mutations.Artist do
  use Absinthe.Schema.Notation

  object :artist_mutations do
    field :create_artist, type: :artist do
      arg(:name, non_null(:string))

      middleware(Dojinlist.Middlewares.Authorization)

      resolve(&create_artist/2)
    end
  end

  def create_artist(attrs, _) do
    case Dojinlist.Artists.create_artist(attrs) do
      {:ok, artist} ->
        {:ok, artist}

      {:error, _changeset} ->
        # @TODO(vy): i18n
        {:error, "Could not create artist"}
    end
  end
end
