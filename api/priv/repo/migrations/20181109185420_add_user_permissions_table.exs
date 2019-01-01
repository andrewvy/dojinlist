defmodule Dojinlist.Repo.Migrations.AddUserPermissionsTable do
  use Ecto.Migration

  def change do
    create table(:permissions) do
      add :type, :string
    end

    create table(:users_permissions) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :permission_id, references(:permissions, on_delete: :delete_all)
    end

    create unique_index(:permissions, [:type])
    create unique_index(:users_permissions, [:user_id, :permission_id])
  end
end
