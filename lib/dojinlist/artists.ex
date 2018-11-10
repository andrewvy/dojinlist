defmodule Dojinlist.Artists do
  alias Dojinlist.{
    Repo,
    Schemas
  }

  def create_artist(attrs) do
    %Schemas.Artist{}
    |> Schemas.Artist.changeset(attrs)
    |> Repo.insert()
  end
end
