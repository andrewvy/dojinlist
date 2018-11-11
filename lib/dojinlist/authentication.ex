defmodule Dojinlist.Authentication do
  alias Dojinlist.{Accounts, Token, Permissions}

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
        # @todo(vy): i18n
        {:error, "Wrong email or password"}

      user ->
        if !is_nil(user.password) && Argon2.verify_pass(password, user.password) do
          after_successful_login(user)
        else
          # @todo(vy): i18n
          {:error, "Wrong email or password"}
        end
    end
  end

  def after_successful_login(user) do
    if Permissions.in_permissions?(user.permissions, "alpha_tester") do
      {:ok, user, generate_token(user.id)}
    else
      # @todo(vy): i18n
      {:error, "Not marked as an alpha tester."}
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
