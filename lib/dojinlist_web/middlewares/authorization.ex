defmodule DojinlistWeb.Middlewares.Authorization do
  @behaviour Absinthe.Middleware

  def call(resolution = %{context: %{current_user: nil}}, _config) do
    resolution
    |> Absinthe.Resolution.put_result(
      {:error,
       %{code: :not_authenticated, error: "Not authenticated", message: "Not authenticated"}}
    )
  end

  def call(resolution = %{context: %{current_user: _}}, _config) do
    resolution
  end
end
