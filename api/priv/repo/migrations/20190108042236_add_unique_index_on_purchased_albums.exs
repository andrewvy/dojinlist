defmodule Dojinlist.Repo.Migrations.AddUniqueIndexOnPurchasedAlbums do
  use Ecto.Migration

  def change do
    create(unique_index(:purchased_albums, [:user_id, :album_id]))
  end
end
