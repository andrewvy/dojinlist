defmodule DojinlistWeb.Mutations.Authentication do
  alias Dojinlist.{Accounts, Authentication}

  # @TODO(vy): i18n, errors-as-data.
  def register(%{email: _, password: _, username: _} = attrs, %{context: %{current_user: nil}}) do
    case Accounts.register(attrs) do
      {:error, changeset} ->
        {:error, DojinlistWeb.ErrorHelpers.flatten_changeset(changeset)}

      {:ok, user} ->
        {:ok, %{user: transform_user(user)}}
    end
  end

  def login(%{email: email, password: password}, _) do
    case Authentication.login(email, password) do
      {:error, message} ->
        {:error, message}

      {:ok, user, token} ->
        {:ok,
         %{
           user: transform_user(user),
           token: token
         }}
    end
  end

  def confirm_email(%{token: token}, _) do
    Dojinlist.Accounts.confirm_email_by_token(token)
  end

  def transform_user(user) do
    Map.take(user, [:id, :username, :email])
  end
end
