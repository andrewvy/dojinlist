defmodule DojinlistWeb.Resolvers.Me do
  def fetch(_, %{context: %{current_user: user}}) do
    {:ok, user}
  end
end
