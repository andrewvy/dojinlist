defmodule Dojinlist.Token do
  def generate(extra_claims) do
    token_config = Joken.Config.default_claims(default_exp: 24 * 60 * 60 * 7)
    {:ok, claims} = Joken.generate_claims(token_config, extra_claims)
    {:ok, jwt, _} = Joken.encode_and_sign(claims, signer())

    jwt
  end

  def verify(token) do
    Joken.verify(token, signer())
  end

  def signer do
    Joken.Signer.create("HS256", token_secret())
  end

  def token_secret do
    System.get_env("JWT_SECRET") || "my_secret"
  end
end
