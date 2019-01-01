defmodule Dojinlist.Repo.Migrations.AddSummaryToBlogPosts do
  use Ecto.Migration

  def change do
    alter table(:blog_posts) do
      add :summary, :text
    end
  end
end
