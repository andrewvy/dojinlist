defmodule Dojinlist.Repo.Migrations.RemoveNonmarketplaceSchemas do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      remove :romanized_title
      remove :japanese_title
      remove :sample_url
      remove :purchase_url
      remove :is_verified
      remove :release_date

      add :title, :text
      add :release_datetime, :utc_datetime
    end

    alter table(:tracks) do
      remove :romanized_title
      remove :japanese_title

      add :title, :text
    end

    alter table(:purchased_albums) do
      add :user_email, :text
    end

    create(unique_index(:purchased_albums, [:user_email, :album_id]))
  end
end
