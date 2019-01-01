defmodule DojinlistWeb.Mutations.Track do
  use Absinthe.Schema.Notation

  alias Dojinlist.{
    Tracks
  }

  object :track_mutations do
    field :update_track, type: :track do
      arg(:track_id, non_null(:id))
      arg(:track, non_null(:track_input))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(DojinlistWeb.Middlewares.Permission, permission: "verify_albums")
      middleware(Absinthe.Relay.Node.ParseIDs, track_id: :track)

      resolve(&update_track/2)
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

        Tracks.update_track(track, updated_attrs)
    end
  end
end
