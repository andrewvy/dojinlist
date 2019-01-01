defmodule Dojinlist.Schemas.UserPermission do
  use Ecto.Schema

  import Ecto.Changeset

  schema "users_permissions" do
    belongs_to :user, Dojinlist.Schemas.User
    belongs_to :permission, Dojinlist.Schemas.Permission
  end

  def changeset(permission, attrs) do
    permission
    |> cast(attrs, [:user_id, :permission_id])
    |> validate_required([:user_id, :permission_id])
    |> unique_constraint(:user_id)
  end
end
