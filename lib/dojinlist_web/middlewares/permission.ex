defmodule DojinlistWeb.Middlewares.Permission do
  @behaviour Absinthe.Middleware

  alias Dojinlist.Permissions

  def call(resolution = %{context: %{current_user: current_user}}, config) do
    permission = Keyword.get(config, :permission)

    if Permissions.in_permissions?(current_user.permissions, permission) do
      resolution
    else
      resolution
      |> Absinthe.Resolution.put_result(
        {:error,
         %{
           code: :does_not_have_permission,
           error: "You don't have permission for this type.",
           message: "You don't have permission for this type."
         }}
      )
    end
  end
end
