defmodule DojinlistWeb.Resolvers.Artist do
  def all(%{search: search} = params, _) do
    Dojinlist.TermSearch.by_artist_name(search)
    |> Absinthe.Relay.Connection.from_list(params)
  end

  def all(params, _) do
    Dojinlist.Schemas.Artist
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
