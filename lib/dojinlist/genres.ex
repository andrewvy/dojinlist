defmodule Dojinlist.Genres do
  alias Dojinlist.{
    Repo,
    Schemas
  }

  import Ecto.Query

  def create_genre(attrs) do
    %Schemas.Genre{}
    |> Schemas.Genre.changeset(attrs)
    |> Repo.insert()
  end

  def get_by_names(names) do
    Schemas.Genre
    |> where([o], o.name in ^names)
    |> Repo.all()
  end
end
