defmodule Dojinlist.Token do
  def base_config() do
    Joken.Config.default_claims(default_exp: 24 * 60 * 60 * 7)
  end

  def generate(extra_claims) do
    {:ok, claims} = Joken.generate_claims(base_config(), extra_claims)
    {:ok, jwt, _} = Joken.encode_and_sign(claims, signer())

    jwt
  end

  def verify(token) do
    Joken.verify_and_validate(base_config(), token, signer())
  end

  def signer do
    Joken.Signer.create("HS256", token_secret())
  end

  def token_secret do
    System.get_env("JWT_SECRET") || "my_secret"
  end
end
