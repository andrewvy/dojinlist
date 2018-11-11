defmodule Dojinlist.Repo.Migrations.AddUserRatingsTable do
  use Ecto.Migration

  def up do
    drop table(:users_likes)

    create table(:users_ratings) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :album_id, references(:albums, on_delete: :delete_all)
      add :rating, :integer
      add :description, :text
    end

    create unique_index(:users_ratings, [:user_id, :album_id])
  end

  def down do
    create table(:users_likes) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :album_id, references(:albums, on_delete: :delete_all)
    end

    create unique_index(:users_likes, [:user_id, :album_id])

    drop table(:users_ratings)
  end
end
