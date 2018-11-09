defmodule DojinlistWeb.Resolvers.Event do
  def all(params, _) do
    Dojinlist.Schemas.Event
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
