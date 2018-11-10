defmodule DojinlistWeb.Mutations.Genre do
  use Absinthe.Schema.Notation

  object :genre_mutations do
    field :create_genre, type: :genre do
      arg(:name, non_null(:string))

      resolve(&create_genre/2)
    end
  end

  def create_genre(attrs, _) do
    case Dojinlist.Genres.create_genre(attrs) do
      {:ok, genre} ->
        {:ok, genre}

      {:error, _changeset} ->
        # @TODO(vy): i18n
        {:error, "Could not create genre"}
    end
  end
end
