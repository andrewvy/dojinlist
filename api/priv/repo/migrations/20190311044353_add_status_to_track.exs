defmodule Dojinlist.Repo.Migrations.AddStatusToTrack do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add(:status, :text)
    end
  end
end
