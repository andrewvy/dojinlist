defmodule DojinlistWeb.Resolvers.OAuth do
  def redirect_url(%{oauth_provider: oauth_provider}, %{context: %{current_user: current_user}}) do
    case oauth_provider do
      "stripe" ->
        redirect_url = Dojinlist.OAuth.Stripe.authorize_url(current_user)
        {:ok, redirect_url}

      _ ->
        {:error, "No OAuth Provider found"}
    end
  end
end
