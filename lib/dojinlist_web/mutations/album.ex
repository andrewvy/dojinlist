defmodule DojinlistWeb.Mutations.Album do
  use Absinthe.Schema.Notation

  object :album_mutations do
    field :create_album, type: :album do
      arg(:name, non_null(:string))
      arg(:sample_url, :string)
      arg(:purchase_url, :string)
      arg(:artist_ids, list_of(:id))
      arg(:genre_ids, list_of(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, artist_ids: :artist)
      middleware(Absinthe.Relay.Node.ParseIDs, genre_ids: :genre)
      middleware(Dojinlist.Middlewares.Authorization)

      resolve(&create_album/2)
    end
  end

  def create_album(attrs, _) do
    case Dojinlist.Albums.create_album(attrs) do
      {:ok, album} ->
        {:ok, album}

      {:error, _changeset} ->
        # @TODO(vy): i18n
        {:error, "Could not create album"}
    end
  end
end
