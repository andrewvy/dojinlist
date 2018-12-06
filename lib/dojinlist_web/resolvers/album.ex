defmodule DojinlistWeb.Resolvers.Album do
  alias Dojinlist.{
    Albums,
    Permissions
  }

  def suggest(%{suggestion: suggestion} = params, _) do
    Dojinlist.AlbumSearch.with_name_suggest(suggestion)
    |> IO.inspect()
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
    |> Dojinlist.Schemas.Album.where_verified?()
    |> Albums.build_query(params)
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end

  def unverified(params, %{context: %{current_user: user}}) do
    if Permissions.in_user_permissions?(user, "verify_albums") do
      Dojinlist.Schemas.Album
      |> Dojinlist.Schemas.Album.where_unverified?()
      |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
    else
      {:ok, %{}}
    end
  end

  def by_id(%{id: id}, %{context: %{current_user: user}}) do
    case Albums.get_album(id) do
      nil ->
        # @TODO(vy): i18n
        {:error, "Could not find album with that id"}

      album ->
        if album.is_verified || Permissions.in_user_permissions?(user, "verify_albums") do
          {:ok, album}
        else
          # @TODO(vy): i18n
          {:error, "Could not find album with that id"}
        end
    end
  end
end
