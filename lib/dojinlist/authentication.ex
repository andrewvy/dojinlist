defmodule Dojinlist.Authentication do
  alias Dojinlist.{Accounts, Token}

  @type error_code :: :not_found | :invalid_password

  @doc """
  Given a email and password, validates if an
  account exists + password is valid and then
  generates a valid JWT token.
  """
  @spec login(String.t(), String.t()) :: {:error, error_code} | {:ok, String.t()}
  def login(email, password) do
    Accounts.get_user_by_email(email)
    |> case do
      nil ->
        {:error, :not_found}

      user ->
        if !is_nil(user.password) && Argon2.verify_pass(password, user.password) do
          {:ok, user, generate_token(user.id)}
        else
          {:error, :invalid_password}
        end
    end
  end

  def generate_token(user_id) do
    claims = %{
      "user_id" => user_id
    }

    Token.generate(claims)
  end

  def verify_token(token) do
    Token.verify(token)
  end
end
