defmodule Dojinlist.Repo.Migrations.AddDefaultPermissions do
  use Ecto.Migration

  alias Dojinlist.Permissions

  def up do
    [
      "verify_albums",
      "modify_permissions",
      "alpha_tester"
    ]
    |> Enum.map(fn permission_type ->
      Permissions.create_permission_type(permission_type)
    end)
  end

  def down do
    [
      "verify_albums",
      "modify_permissions",
      "alpha_tester"
    ]
    |> Enum.map(fn permission_type ->
      Permissions.remove_permission_type(permission_type)
    end)
  end
end
