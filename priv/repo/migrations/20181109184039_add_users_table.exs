defmodule Dojinlist.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :uuid, :uuid, default: fragment("uuid_generate_v4()")
      add :username, :string
      add :email, :string
      add :password, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end
end
