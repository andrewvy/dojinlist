defmodule Dojinlist.Repo.Migrations.RenameNamesOnAlbums do
  use Ecto.Migration

  def change do
    rename table(:albums), :name, to: :romanized_title
    rename table(:albums), :kana_name, to: :japanese_title

    rename table(:tracks), :title, to: :romanized_title
    rename table(:tracks), :kana_title, to: :japanese_title
  end
end
