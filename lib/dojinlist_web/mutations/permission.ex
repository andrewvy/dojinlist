defmodule DojinlistWeb.Mutations.Permission do
  use Absinthe.Schema.Notation

  object :permission_mutations do
    field :add_permission_to_user, type: :user do
      arg(:permission_type, non_null(:string))
      arg(:user_id, non_null(:id))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(DojinlistWeb.Middlewares.Permission, permission: "modify_permissions")
      middleware(Absinthe.Relay.Node.ParseIDs, user_id: :user)

      resolve(&add_permission_to_user/2)
    end

    field :remove_permission_from_user, type: :user do
      arg(:permission_type, non_null(:string))
      arg(:user_id, non_null(:id))

      middleware(DojinlistWeb.Middlewares.Authorization)
      middleware(DojinlistWeb.Middlewares.Permission, permission: "modify_permissions")
      middleware(Absinthe.Relay.Node.ParseIDs, user_id: :user)

      resolve(&remove_permission_from_user/2)
    end
  end

  def add_permission_to_user(%{permission_type: permission_type, user_id: user_id}, _) do
    case Dojinlist.Accounts.get_user(user_id) do
      nil ->
        {:error, "User does not exist"}

      user ->
        case Dojinlist.Permissions.add_permission_to_user(user, permission_type) do
          {:ok, _} -> {:ok, user}
          error -> error
        end
    end
  end

  def remove_permission_from_user(%{permission_type: permission_type, user_id: user_id}, _) do
    case Dojinlist.Accounts.get_user(user_id) do
      nil ->
        {:error, "User does not exist"}

      user ->
        case Dojinlist.Permissions.remove_permission_from_user(user, permission_type) do
          {:ok, _} -> {:ok, user}
          error -> error
        end
    end
  end
end
