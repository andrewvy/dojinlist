defmodule DojinlistWeb.Mutations.Track do
  use Absinthe.Schema.Notation

  alias Dojinlist.{
    Albums,
    Tracks
  }

  object :track_mutations do
    field :create_track, type: :track_response do
      arg(:album_id, non_null(:id))
      arg(:track, non_null(:track_input))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)
      middleware(DojinlistWeb.Middlewares.StorefrontAuthorized, album_id: :album)

      resolve(&create_track/2)
    end

    field :update_track, type: :track_response do
      arg(:track_id, non_null(:id))
      arg(:track, non_null(:track_update_input))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(Absinthe.Relay.Node.ParseIDs, track_id: :track)
      middleware(DojinlistWeb.Middlewares.StorefrontAuthorized, track_id: :track)

      resolve(&update_track/2)
    end
  end

  def create_track(%{track: track_attrs, album_id: album_id}, _) do
    # @todo(vy): Check if current user has permission to add new track.
    case Albums.get_album(album_id) do
      nil ->
        {:error, "Could not find an album with that id"}

      album ->
        with {:upload, {:ok, source_file}} <-
               {:upload, handle_source_file(track_attrs[:source_file])},
             track_attrs = Map.put(track_attrs, :source_file, source_file),
             {:ok, track} <- Tracks.create_track(album.id, track_attrs) do
          {:ok, %{track: track}}
        else
          {:upload, _} ->
            %{
              errors: [
                DojinlistWeb.Errors.track_audio_unsupported()
              ]
            }

          _error ->
            %{
              errors: [
                DojinlistWeb.Errors.create_track_failed()
              ]
            }
        end
    end
  end

  def update_track(%{track_id: track_id} = attrs, _) do
    case Tracks.get_by_id(track_id) do
      nil ->
        {:error, "Could not find a track with that id"}

      track ->
        updated_attrs =
          attrs
          |> Map.get(:track, %{})

        case Tracks.update_track(track, updated_attrs) do
          {:ok, track} ->
            {:ok, %{track: track}}

          _ ->
            %{
              errors: [
                DojinlistWeb.Errors.update_track_failed()
              ]
            }
        end
    end
  end

  def handle_source_file(nil), do: {:ok, ""}

  def handle_source_file(source_file) do
    source_file
    |> Dojinlist.Uploaders.rewrite_upload()
    |> Dojinlist.SourceFileAttachment.store()
  end
end
