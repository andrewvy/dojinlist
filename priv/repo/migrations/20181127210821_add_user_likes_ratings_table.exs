defmodule Dojinlist.Repo.Migrations.AddUserLikesRatingsTable do
  use Ecto.Migration

  def change do
    create table(:users_likes_ratings) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :rating_id, references(:users_ratings, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:users_likes_ratings, [:user_id, :rating_id])
  end
end
