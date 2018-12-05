defmodule Dojinlist.Repo.Migrations.AddExternalLinksToAlbums do
  use Ecto.Migration

  def change do
    create table(:external_album_links) do
      add :url, :text
      add :type, :string

      add :album_id, references(:albums, on_delete: :delete_all)
    end
  end
end
