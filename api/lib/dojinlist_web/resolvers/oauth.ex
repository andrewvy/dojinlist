defmodule DojinlistWeb.Resolvers.OAuth do
  def stripe_redirect_url(_params, %{context: %{current_user: current_user}}) do
    redirect_url = Dojinlist.OAuth.Stripe.authorize_url(current_user)

    {:ok, redirect_url}
  end
end
