defmodule Dojinlist.Repo.Migrations.AddManageBlogPermission do
  use Ecto.Migration

  alias Dojinlist.Permissions

  def up do
    [
      "manage_blog"
    ]
    |> Enum.map(fn permission_type ->
      Permissions.create_permission_type(permission_type)
    end)
  end

  def down do
    [
      "manage_blog"
    ]
    |> Enum.map(fn permission_type ->
      Permissions.remove_permission_type(permission_type)
    end)
  end
end
