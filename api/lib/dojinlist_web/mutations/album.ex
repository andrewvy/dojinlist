defmodule DojinlistWeb.Mutations.Album do
  use Absinthe.Schema.Notation

  alias Dojinlist.Albums

  object :album_mutations do
    field :create_album, type: :album_response do
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

    field :update_album, type: :album_response do
      arg(:album_id, non_null(:id))
      arg(:album, non_null(:album_input))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)
      middleware(DojinlistWeb.Middlewares.StorefrontAuthorized, album_id: :album)

      resolve(&update_album/2)
    end
  end

  def create_album(%{album: album_attrs}, %{context: %{current_user: user}}) do
    with {:ok, cover_art} <- handle_cover_art(album_attrs[:cover_art]),
         merged_attrs = Map.merge(album_attrs, %{cover_art: cover_art, creator_user_id: user.id}),
         {:ok, album} <- handle_create_album(merged_attrs) do
      {:ok,
       %{
         album: Dojinlist.Repo.preload(album, [:event, :artists, :genres])
       }}
    else
      _ -> {:ok, %{errors: [DojinlistWeb.Errors.create_album_failed()]}}
    end
  end

  def update_album(%{album: album_attrs, album_id: album_id}, _) do
    case Albums.get_album(album_id) do
      nil ->
        {:ok,
         %{
           errors: [
             DojinlistWeb.Errors.album_not_found()
           ]
         }}

      album ->
        with {:ok, cover_art} <- handle_cover_art(album_attrs[:cover_art]),
             merged_attrs = Map.merge(album_attrs, %{cover_art: cover_art}),
             {:ok, album} <- Albums.update_album(album, merged_attrs) do
          {:ok,
           %{
             album: Dojinlist.Repo.preload(album, [:event, :artists, :genres])
           }}
        else
          _ -> {:ok, %{errors: [DojinlistWeb.Errors.update_album_failed()]}}
        end
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
        {:error, "Could not create album"}
    end
  end

  defp handle_cover_art(nil), do: {:ok, nil}

  defp handle_cover_art(cover_art) do
    Dojinlist.Uploaders.rewrite_upload(cover_art)
    |> Dojinlist.ImageAttachment.store()
  end
end
