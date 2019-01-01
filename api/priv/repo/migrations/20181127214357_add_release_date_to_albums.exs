defmodule Dojinlist.Repo.Migrations.AddReleaseDateToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :release_date, :utc_datetime
    end
  end
end
