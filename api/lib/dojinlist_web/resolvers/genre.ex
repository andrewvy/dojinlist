defmodule DojinlistWeb.Resolvers.Genre do
  def all(%{search: search} = params, _) do
    Dojinlist.TermSearch.by_genre_name(search)
    |> Absinthe.Relay.Connection.from_list(params)
  end

  def all(params, _) do
    Dojinlist.Schemas.Genre
    |> Absinthe.Relay.Connection.from_query(&Dojinlist.Repo.all/1, params)
  end
end
