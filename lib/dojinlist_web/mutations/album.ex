defmodule DojinlistWeb.Mutations.Album do
  use Absinthe.Schema.Notation

  object :album_mutations do
    field :create_album, type: :album do
      arg(:name, non_null(:string))
      arg(:sample_url, :string)
      arg(:purchase_url, :string)
      arg(:artist_ids, list_of(:id))
      arg(:genre_ids, list_of(:id))
      arg(:event_id, :id)

      middleware(Absinthe.Relay.Node.ParseIDs, artist_ids: :artist)
      middleware(Absinthe.Relay.Node.ParseIDs, genre_ids: :genre)
      middleware(Absinthe.Relay.Node.ParseIDs, event_id: :event)
      middleware(Dojinlist.Middlewares.Authorization)

      resolve(&create_album/2)
    end

    field :mark_album_as_verified, type: :album do
      arg(:album_id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)
      middleware(Dojinlist.Middlewares.Authorization)
      middleware(Dojinlist.Middlewares.Permission, permission: "verify_albums")
    end

    field :mark_album_as_unverified, type: :album do
      arg(:album_id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)
      middleware(Dojinlist.Middlewares.Authorization)
      middleware(Dojinlist.Middlewares.Permission, permission: "verify_albums")
    end
  end

  def create_album(attrs, _) do
    case Dojinlist.Albums.create_album(attrs) do
      {:ok, album} ->
        {:ok, Dojinlist.Repo.preload(album, [:event, :artists, :genres])}

      {:error, _changeset} ->
        # @TODO(vy): i18n
        {:error, "Could not create album"}
    end
  end

  def mark_as_verified(%{album_id: album_id}, _) do
    Dojinlist.Albums.mark_as_verified(album_id)
  end

  def mark_as_unverified(%{album_id: album_id}, _) do
    Dojinlist.Albums.mark_as_unverified(album_id)
  end
end
