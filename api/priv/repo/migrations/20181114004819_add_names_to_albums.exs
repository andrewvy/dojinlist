defmodule Dojinlist.Repo.Migrations.AddNamesToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :kana_name, :text
    end
  end
end
