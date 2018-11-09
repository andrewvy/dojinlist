defmodule DojinlistWeb.Mutations.Authentication do
  alias Dojinlist.{Accounts, Authentication}

  def register(%{email: _, password: _, username: _} = attrs, %{context: %{current_user: nil}}) do
    case Accounts.register(attrs) do
      {:error, _changeset} -> {:error, "Error creating new account"}
      {:ok, user} -> {:ok, %{user: transform_user(user)}}
    end
  end

  def register(_attrs, %{context: %{current_user: _}}) do
    {:error, "Already logged in!"}
  end

  def login(_, %{context: %{current_user: _}}) do
    {:error, "Already logged in!"}
  end

  def login(%{email: email, password: password}, _) do
    case Authentication.login(email, password) do
      {:error, _} ->
        {:error, "Wrong email or password"}

      {:ok, user, token} ->
        {:ok,
         %{
           user: transform_user(user),
           token: token
         }}
    end
  end

  def transform_user(user) do
    Map.take(user, [:id, :username, :email])
  end
end
