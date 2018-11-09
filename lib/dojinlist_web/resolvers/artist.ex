defmodule DojinlistWeb.Resolvers.Artist do
  def all(params, _) do
    Dojinlist.Schemas.Artist
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
