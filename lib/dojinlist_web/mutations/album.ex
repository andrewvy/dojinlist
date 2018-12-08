defmodule DojinlistWeb.Mutations.Album do
  use Absinthe.Schema.Notation

  object :album_mutations do
    field :create_album, type: :album do
      arg(:album, non_null(:album_input))

      middleware(Absinthe.Relay.Node.ParseIDs, artist_ids: :artist)
      middleware(Absinthe.Relay.Node.ParseIDs, genre_ids: :genre)
      middleware(Absinthe.Relay.Node.ParseIDs, event_id: :event)
      middleware(DojinlistWeb.Middlewares.Authorization)

      resolve(&create_album/2)
    end

    field :mark_album_as_verified, type: :album do
      arg(:album_id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)
      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(DojinlistWeb.Middlewares.Permission, permission: "verify_albums")
    end

    field :mark_album_as_unverified, type: :album do
      arg(:album_id, non_null(:id))

      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)
      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(DojinlistWeb.Middlewares.Permission, permission: "verify_albums")
    end
  end

  def create_album(%{album: album_attrs}, %{context: %{current_user: user}}) do
    with {:ok, cover_art} <- handle_cover_art(album_attrs[:cover_art]),
         merged_attrs = Map.merge(album_attrs, %{cover_art: cover_art, creator_user_id: user.id}),
         {:ok, album} <- handle_create_album(merged_attrs) do
      {:ok, Dojinlist.Repo.preload(album, [:event, :artists, :genres])}
    else
      {:error, _} = error -> error
      _ -> {:error, "Error while submitting album"}
    end
  end

  def mark_as_verified(%{album_id: album_id}, _) do
    Dojinlist.Albums.mark_as_verified(album_id)
  end

  def mark_as_unverified(%{album_id: album_id}, _) do
    Dojinlist.Albums.mark_as_unverified(album_id)
  end

  defp handle_create_album(attrs) do
    case Dojinlist.Albums.create_album(attrs) do
      {:ok, album} ->
        attrs
        |> Map.get(:tracks, [])
        |> Enum.map(fn track_input ->
          Dojinlist.Tracks.create_track(album.id, track_input)
        end)

        {:ok, album}

      {:error, _changeset} ->
        # @TODO(vy): i18n
        {:error, "Could not create album"}
    end
  end

  defp handle_cover_art(nil), do: {:ok, nil}

  defp handle_cover_art(cover_art) do
    Dojinlist.Uploaders.rewrite_upload(cover_art)
    |> Dojinlist.ImageAttachment.store()
  end
end
