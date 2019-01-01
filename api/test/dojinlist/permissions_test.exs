defmodule Dojinlist.PermissionsTest do
  use Dojinlist.DataCase

  alias Dojinlist.Permissions

  test "Can create permission types" do
    assert {:ok, permission} = Permissions.create_permission_type("test_verify_albums")
  end

  test "Can add and remove permissions from user" do
    {:ok, user} = Dojinlist.Fixtures.user()
    {:ok, permission} = Permissions.create_permission_type("test_verify_albums")

    {:ok, user_permission} = Permissions.add_permission_to_user(user, "test_verify_albums")

    assert user_permission.permission_id == permission.id

    {:ok, _removed} = Permissions.remove_permission_from_user(user, "test_verify_albums")

    loaded_user = user |> Repo.preload([:permissions])

    assert [] == loaded_user.permissions
  end

  test "Cannot add invalid permissions to user" do
    {:ok, user} = Dojinlist.Fixtures.user()

    assert {:error, _} = Permissions.add_permission_to_user(user, "test_verify_albums")
  end

  test "Can check for permissions" do
    {:ok, user} = Dojinlist.Fixtures.user()
    {:ok, _} = Permissions.create_permission_type("test_verify_albums")
    {:ok, _} = Permissions.add_permission_to_user(user, "test_verify_albums")

    loaded_user = user |> Repo.preload([:permissions])

    assert true == Permissions.in_permissions?(loaded_user.permissions, "test_verify_albums")
  end
end
