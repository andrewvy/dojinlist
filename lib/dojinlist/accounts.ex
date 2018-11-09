defmodule Dojinlist.Accounts do
  alias Dojinlist.Schemas.User
  alias Dojinlist.Repo

  import Ecto.Query

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user_by_email(email) do
    User
    |> where(email: ^email)
    |> Repo.one()
  end

  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
