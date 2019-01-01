defmodule Dojinlist.Artists do
  alias Dojinlist.{
    Repo,
    Schemas
  }

  import Ecto.Query

  def create_artist(attrs) do
    %Schemas.Artist{}
    |> Schemas.Artist.changeset(attrs)
    |> Repo.insert()
  end

  def get_by_names(names) do
    Schemas.Artist
    |> where([o], o.name in ^names)
    |> Repo.all()
  end
end
