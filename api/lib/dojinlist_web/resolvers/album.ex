defmodule DojinlistWeb.Resolvers.Album do
  alias Dojinlist.Albums

  def suggest(%{suggestion: suggestion} = params, _) do
    Dojinlist.AlbumSearch.with_title_suggest(suggestion)
    |> case do
      {:ok, search} ->
        docs =
          search["suggest"]["name_suggest"]
          |> Enum.map(fn doc ->
            doc["_source"]
          end)
          |> Enum.reject(&is_nil/1)

        docs
        |> Absinthe.Relay.Connection.from_list(params)

      _ ->
        {:error, "Could not search albums at this time."}
    end
  end

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
