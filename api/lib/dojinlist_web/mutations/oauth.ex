defmodule DojinlistWeb.Mutations.OAuth do
  use Absinthe.Schema.Notation

  object :oauth_mutations do
    field :stripe_exchange_code, type: :stripe_oauth_response do
      arg(:state, non_null(:string))
      arg(:code, non_null(:string))

      middleware(DojinlistWeb.Middlewares.Authorization)

      resolve(&stripe_exchange_code/2)
    end
  end

  def stripe_exchange_code(attrs, %{context: %{current_user: current_user}}) do
    Dojinlist.OAuth.Stripe.exchange_code(current_user, attrs[:state], attrs[:code])
    |> case do
      {:ok, _} ->
        {:ok, %{user: current_user}}

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
