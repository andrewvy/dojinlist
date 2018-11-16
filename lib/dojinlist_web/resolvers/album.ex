defmodule DojinlistWeb.Resolvers.Album do
  alias Dojinlist.{
    Albums,
    Permissions
  }

  def all(params, _) do
    Dojinlist.Schemas.Album
    |> Dojinlist.Schemas.Album.where_verified?()
    |> Albums.build_query(params)
    |> Dojinlist.Schemas.Album.preload()
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end

  def unverified(params, %{context: %{current_user: user}}) do
    if Permissions.in_user_permissions?(user, "verify_albums") do
      Dojinlist.Schemas.Album
      |> Dojinlist.Schemas.Album.where_unverified?()
      |> Dojinlist.Schemas.Album.preload()
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
