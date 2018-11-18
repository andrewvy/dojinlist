defmodule Dojinlist.Repo.Migrations.AddUserIdToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :creator_user_id, references(:users)
    end
  end
end
