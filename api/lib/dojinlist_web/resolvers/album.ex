defmodule DojinlistWeb.Resolvers.Album do
  alias Dojinlist.Albums

  def all(params, _) do
    Dojinlist.Schemas.Album
    |> Albums.build_query(params)
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end

  def by_id(%{id: id}, _) do
    case Albums.get_album(id) do
      nil ->
        # @TODO(vy): i18n
        {:error, "Could not find album with that id"}

      album ->
        {:ok, album}
    end
  end
end
