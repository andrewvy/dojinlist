defmodule Dojinlist.Repo.Migrations.AddSourceFileToTrack do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add(:source_file, :text)
    end
  end
end
