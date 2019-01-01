defmodule Dojinlist.Events do
  alias Dojinlist.{
    Repo,
    Schemas
  }

  import Ecto.Query

  def create_event(attrs) do
    %Schemas.Event{}
    |> Schemas.Event.changeset(attrs)
    |> Repo.insert()
  end

  def get_by_id(id) do
    Schemas.Event
    |> Repo.get(id)
  end

  def get_by_name(name) do
    Schemas.Event
    |> where([o], o.name == ^name)
    |> Repo.one()
  end

  def by_name(name) do
    Schemas.Event
    |> where([e], ilike(e.name, ^"%#{name}%"))
  end
end
