defmodule Dojinlist.Genres do
  alias Dojinlist.{
    Repo,
    Schemas
  }

  def create_genre(attrs) do
    %Schemas.Genre{}
    |> Schemas.Genre.changeset(attrs)
    |> Repo.insert()
  end
end
