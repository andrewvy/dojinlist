defmodule DojinlistWeb.Resolvers.Genre do
  def all(params, _) do
    Dojinlist.Schemas.Genre
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
