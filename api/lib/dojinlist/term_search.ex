defmodule Dojinlist.TermSearch do
  import Ecto.Query

  alias Dojinlist.Repo

  def by_artist_name(input) do
    Dojinlist.Schemas.Artist
    |> query(input)
    |> Repo.all()
  end

  def by_genre_name(input) do
    Dojinlist.Schemas.Genre
    |> query(input)
    |> Repo.all()
  end

  def query(queryable, search_term) do
    where(
      queryable,
      fragment(
        "to_tsvector(name) @@
        to_tsquery(?)",
        ^prefix_search(search_term)
      )
    )
  end

  defp prefix_search(""), do: ""
  defp prefix_search(term), do: String.replace(term, ~r/\W/u, "") <> ":*"
end
