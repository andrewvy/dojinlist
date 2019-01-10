defmodule DojinlistWeb.Mutations.Album do
  use Absinthe.Schema.Notation

  object :album_mutations do
    field :create_album, type: :album do
      arg(:album, non_null(:album_input))

      middleware(
        Absinthe.Relay.Node.ParseIDs,
        album: [
          storefront_id: :storefront,
          artist_ids: :artist,
          genre_ids: :genre,
          event_id: :event
        ]
      )

      middleware(DojinlistWeb.Middlewares.Authorization)

      resolve(&create_album/2)
    end
  end

  def create_album(%{album: album_attrs}, %{context: %{current_user: user}}) do
    with {:ok, cover_art} <- handle_cover_art(album_attrs[:cover_art]),
         merged_attrs = Map.merge(album_attrs, %{cover_art: cover_art, creator_user_id: user.id}),
         {:ok, album} <- handle_create_album(merged_attrs) do
      {:ok, Dojinlist.Repo.preload(album, [:event, :artists, :genres])}
    else
      {:error, _} = error -> error
      # @TODO(vy): i18n
      _ -> {:error, "Error while submitting album"}
    end
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
