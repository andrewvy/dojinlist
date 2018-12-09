defmodule DojinlistWeb.Resolvers.Event do
  alias Dojinlist.Events

  def all(%{name: name} = params, _) do
    Events.by_name(name)
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end

  def all(params, _) do
    Dojinlist.Schemas.Event
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
