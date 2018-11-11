defmodule Dojinlist.Middlewares.Unauthorization do
  @behaviour Absinthe.Middleware

  def call(resolution = %{context: %{current_user: nil}}, _config) do
    resolution
  end

  def call(resolution = %{context: %{current_user: _}}, _config) do
    resolution
    |> Absinthe.Resolution.put_result(
      {:error, %{code: :authenticated, error: "Authenticated", message: "Already authenticated"}}
    )
  end
end
