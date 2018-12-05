defmodule Dojinlist.Repo.Migrations.AddTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :title, :text
      add :kana_title, :text
      add :play_length, :integer

      add :album_id, references(:albums, on_delete: :delete_all)
    end
  end
end
