defmodule Dojinlist.Permissions do
  alias Dojinlist.Schemas
  alias Dojinlist.Repo

  import Ecto.Query

  def create_permission_type(type) do
    %Schemas.Permission{}
    |> Schemas.Permission.changeset(%{type: type})
    |> Repo.insert()
  end

  def remove_permission_type(type) do
    Schemas.Permission
    |> where([p], p.type == ^type)
    |> Repo.delete_all()
  end

  def get_permission_by_type(type) do
    Schemas.Permission
    |> where([p], p.type == ^type)
    |> Repo.one()
  end

  def get_permissions() do
    Schemas.Permission
    |> Repo.all()
  end

  def get_permissions_for_user(user) do
    loaded_user = user |> Repo.preload([:permissions])
    loaded_user.permissions
  end

  def add_permission_to_user(user, permission_type) do
    get_permission_by_type(permission_type)
    |> case do
      nil ->
        {:error, "Could not find permission with type: #{permission_type}"}

      permission ->
        %Schemas.UserPermission{}
        |> Schemas.UserPermission.changeset(%{user_id: user.id, permission_id: permission.id})
        |> Repo.insert()
        |> case do
          {:ok, user_permission} ->
            {:ok, user_permission}

          {:error, _} ->
            {:error, "User already has this permission: #{permission_type}"}
        end
    end
  end

  def remove_permission_from_user(user, permission_type) do
    get_permission_by_type(permission_type)
    |> case do
      nil ->
        {:error, "Could not find permission with type: #{permission_type}"}

      permission ->
        Schemas.UserPermission
        |> where([up], up.user_id == ^user.id and up.permission_id == ^permission.id)
        |> Repo.one()
        |> case do
          nil ->
            {:error, "User did not have permission with type: #{permission_type}"}

          user_permission ->
            Repo.delete(user_permission)
            |> case do
              {:ok, user_permission} ->
                {:ok, user_permission}

              {:error, _} ->
                {:error, "Error removing permission #{permission_type} from user"}
            end
        end
    end
  end

  def in_user_permissions?(nil, _type), do: false

  def in_user_permissions?(%Schemas.User{permissions: permissions}, type)
      when is_list(permissions),
      do: in_permissions?(permissions, type)

  def in_user_permissions?(_, _), do: false

  def in_permissions?(permissions, type) do
    permissions
    |> Enum.any?(fn permission ->
      permission.type == type
    end)
  end
end
