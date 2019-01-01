defmodule Dojinlist.Repo.Migrations.AddBlogPostsTable do
  use Ecto.Migration

  def change do
    create table(:blog_posts) do
      add :user_id, references(:users)
      add :title, :text
      add :slug, :text
      add :content, :text

      timestamps()
    end

    create unique_index(:blog_posts, [:slug])
  end
end
