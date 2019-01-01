defmodule Dojinlist.Repo.Migrations.AddUserLikesTable do
  use Ecto.Migration

  def change do
    create table(:users_likes) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :album_id, references(:albums, on_delete: :delete_all)
    end

    create unique_index(:users_likes, [:user_id, :album_id])
  end
end
