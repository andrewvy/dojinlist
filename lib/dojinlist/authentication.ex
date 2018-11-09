defmodule Dojinlist.Authentication do
  alias Dojinlist.Accounts

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
    %{"user_id" => user_id}
    |> Joken.token()
    |> Joken.with_signer(Joken.hs256(token_secret()))
    |> Joken.with_iat()
    # Sets token expiry at 7 days.
    |> Joken.with_exp(current_time() + 24 * 60 * 60 * 7)
    |> Joken.sign()
    |> Joken.get_compact()
  end

  def verify_token(token) do
    token_struct =
      token
      |> Joken.token()
      |> Joken.with_signer(Joken.hs256(token_secret()))
      |> Joken.with_validation("exp", &(&1 > current_time()))
      |> Joken.verify()

    if valid_token?(token_struct) do
      {:ok, token_struct}
    else
      {:error, token_struct}
    end
  end

  def current_time() do
    DateTime.utc_now() |> DateTime.to_unix()
  end

  def valid_token?(%Joken.Token{error: nil}), do: true
  def valid_token?(%Joken.Token{error: _}), do: false

  def token_secret do
    System.get_env("JWT_SECRET") || "my_secret"
  end
end
