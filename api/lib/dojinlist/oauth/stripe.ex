defmodule Dojinlist.OAuth.Stripe do
  alias Dojinlist.Schemas.StripeAccount
  alias Dojinlist.Repo

  if Mix.env() == :prod do
    @stripe_client_id "ca_EGFzYHQNiNY183CULTmDOTYzpwYzmEV5"
  else
    @stripe_client_id "ca_EGFzw5b4SW5uHxTZpcrPKhky5G9CD3j5"
  end

  def authorize_url(user) do
    Stripe.Connect.OAuth.authorize_url(%{
      client_id: @stripe_client_id,
      response_type: "code",
      scope: "read_write",
      state: generate_state(user)
    })
  end

  def exchange_code(user, state, code) do
    if verify_state?(user, state) do
      case Stripe.Connect.OAuth.token(code) do
        {:ok, response} ->
          %StripeAccount{}
          |> StripeAccount.changeset(%{
            access_token: response.access_token,
            scope: response.scope,
            livemode: response.livemode,
            refresh_token: response.refresh_token,
            stripe_user_id: response.stripe_user_id,
            stripe_publishable_key: response.stripe_publishable_key,
            user_id: user.id
          })
          |> Repo.insert()

        {:error, _} ->
          {:error, "Error connecting to Stripe"}
      end
    else
      {:error, "State is not valid"}
    end
  end

  def generate_state(user) do
    Phoenix.Token.sign(DojinlistWeb.Endpoint, "stripe oauth", user.id)
  end

  def verify_state?(user, state) do
    Phoenix.Token.verify(DojinlistWeb.Endpoint, "stripe oauth", state, max_age: 86_400)
    |> case do
      {:ok, user_id} -> user_id == user.id
      _ -> false
    end
  end
end
