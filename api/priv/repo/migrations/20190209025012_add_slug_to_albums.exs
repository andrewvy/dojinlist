defmodule Dojinlist.Repo.Migrations.AddSlugToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add(:slug, :text)
    end

    create(unique_index(:albums, [:slug, :storefront_id]))
  end
end
