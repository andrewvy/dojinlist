defmodule DojinlistWeb.Mutations.OAuth do
  use Absinthe.Schema.Notation

  object :oauth_mutations do
    field :exchange_code, type: :oauth_response do
      arg(:oauth_provider, non_null(:string))
      arg(:state, non_null(:string))
      arg(:code, non_null(:string))

      middleware(DojinlistWeb.Middlewares.Authorization)

      resolve(&exchange_code/2)
    end
  end

  def exchange_code(%{state: state, code: code, oauth_provider: "stripe"}, %{
        context: %{current_user: current_user}
      }) do
    Dojinlist.OAuth.Stripe.exchange_code(current_user, state, code)
    |> case do
      {:ok, _} ->
        {:ok, %{user: current_user, oauth_provider: "stripe"}}

      {:error, _} ->
        errors = [
          %{
            error_code: "STRIPE_OAUTH_FAILED",
            error_message: "Stripe authentication has unexpectedly failed."
          }
        ]

        {:ok, %{errors: errors}}
    end
  end
end
