defmodule Dojinlist.Repo.Migrations.AddIsVerifiedToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :is_verified, :boolean, default: false
    end
  end
end
