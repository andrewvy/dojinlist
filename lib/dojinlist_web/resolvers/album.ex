defmodule DojinlistWeb.Resolvers.Album do
  def all(params, _) do
    Dojinlist.Schemas.Album
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
