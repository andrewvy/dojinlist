defmodule DojinlistWeb.Context do
  @behaviour Plug

  import Plug.Conn

  alias Dojinlist.{
    Accounts,
    Authentication
  }

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{current_user: nil}
    end
  end

  defp authorize(token) do
    with {:ok, claims} <- Authentication.verify_token(token),
         user_id = Map.get(claims, "user_id"),
         true <- !is_nil(user_id),
         user = Accounts.get_user(user_id),
         true <- !is_nil(user) do
      loaded_user = user |> Dojinlist.Repo.preload([:permissions])

      {:ok, loaded_user}
    else
      _ -> {:error, "Could not authorize token"}
    end
  end
end
