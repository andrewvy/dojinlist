defmodule Dojinlist.Repo.Migrations.AddStatusToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add(:status, :text)
    end

    create(index(:tracks, [:status]))
    create(index(:albums, [:status]))
  end
end
