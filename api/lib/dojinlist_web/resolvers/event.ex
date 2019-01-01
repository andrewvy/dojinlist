defmodule DojinlistWeb.Resolvers.Event do
  alias Dojinlist.Events

  def all(%{search: search} = params, _) do
    Events.by_name(search)
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end

  def all(params, _) do
    Dojinlist.Schemas.Event
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
