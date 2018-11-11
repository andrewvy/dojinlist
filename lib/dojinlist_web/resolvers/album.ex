defmodule DojinlistWeb.Resolvers.Album do
  def all(params, _) do
    Dojinlist.Schemas.Album
    |> Dojinlist.Schemas.Album.where_verified?()
    |> Dojinlist.Schemas.Album.preload()
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end

  def unverified(params, _) do
    Dojinlist.Schemas.Album
    |> Dojinlist.Schemas.Album.where_unverified?()
    |> Dojinlist.Schemas.Album.preload()
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
