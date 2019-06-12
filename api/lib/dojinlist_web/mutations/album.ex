defmodule DojinlistWeb.Mutations.Album do
  use Absinthe.Schema.Notation

  alias Dojinlist.{
    Albums,
    Tracks
  }

  alias DojinlistWeb.Mutations

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

    field :delete_album, type: :album_id_response do
      arg(:album_id, non_null(:id))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)
      middleware(DojinlistWeb.Middlewares.StorefrontAuthorized, album_id: :album)

      resolve(&delete_album/2)
    end

    field :publish_album, type: :album_id_response do
      arg(:album_id, non_null(:id))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)
      middleware(DojinlistWeb.Middlewares.StorefrontAuthorized, album_id: :album)

      resolve(&publish_album/2)
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
      {:error, :album_name_already_exists} ->
        {:ok, %{errors: [DojinlistWeb.Errors.album_name_already_exists()]}}

      _ ->
        {:ok, %{errors: [DojinlistWeb.Errors.create_album_failed()]}}
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

  def delete_album(%{album_id: album_id}, _) do
    case Albums.get_album(album_id) do
      nil ->
        {:ok,
         %{
           errors: [
             DojinlistWeb.Errors.album_not_found()
           ]
         }}

      album ->
        Albums.delete_album(album)
        |> case do
          {:ok, album} ->
            {:ok,
             %{
               album_id: Absinthe.Relay.Node.to_global_id(:album, album.id, DojinlistWeb.Schema)
             }}

          {:error, _} ->
            {:ok,
             %{
               errors: [
                 DojinlistWeb.Errors.delete_album_failed()
               ]
             }}
        end
    end
  end

  def publish_album(%{album_id: album_id}, _) do
    case Albums.get_album(album_id) do
      nil ->
        {:ok,
         %{
           errors: [
             DojinlistWeb.Errors.album_not_found()
           ]
         }}

      album ->
        Albums.publish_album(album)
        |> case do
          {:ok, album} ->
            {:ok,
             %{
               album_id: Absinthe.Relay.Node.to_global_id(:album, album.id, DojinlistWeb.Schema)
             }}

          {:error, _} ->
            {:ok,
             %{
               errors: [
                 DojinlistWeb.Errors.publish_album_failed()
               ]
             }}
        end
    end
  end

  # ---
  # Private
  # ---

  defp handle_create_album(attrs) do
    case Dojinlist.Albums.create_album(attrs) do
      {:ok, album} ->
        track_responses =
          attrs
          |> Map.get(:tracks, [])
          |> Enum.map(&handle_create_track(album, &1))

        if Enum.any?(track_responses, fn {status, _} -> status === :error end) do
          {:error, "Could not upload track file."}
        else
          {:ok, album}
        end

      {:error, changeset} ->
        slug_error =
          changeset.errors
          |> Keyword.get(:slug)

        if slug_error do
          {:error, :album_name_already_exists}
        else
          {:error, :create_album_failed}
        end
    end
  end

  defp handle_create_track(album, track_input) do
    with {:ok, track_attrs} <-
           Tracks.validate_and_merge_attrs(track_input, track_input[:source_file]),
         {:ok, source_file} <- Mutations.Track.handle_source_file(track_input[:source_file]) do
      merged_track_input = Map.put(track_attrs, :source_file, source_file)
      Dojinlist.Tracks.create_track(album.id, merged_track_input)
    else
      {:error, :audio_not_supported} ->
        {:error, DojinlistWeb.Errors.track_audio_unsupported()}

      _ ->
        {:error, track_input}
    end
  end

  defp handle_cover_art(nil), do: {:ok, nil}

  defp handle_cover_art(cover_art) do
    Dojinlist.Uploaders.rewrite_upload(cover_art)
    |> Dojinlist.ImageAttachment.store()
  end
end
