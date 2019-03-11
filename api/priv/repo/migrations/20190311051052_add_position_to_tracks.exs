defmodule Dojinlist.Repo.Migrations.AddPositionToTracks do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add(:position, :integer)
    end
  end
end
