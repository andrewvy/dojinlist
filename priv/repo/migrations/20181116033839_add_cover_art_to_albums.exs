defmodule Dojinlist.Repo.Migrations.AddCoverArtToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :cover_art, :text
    end
  end
end
