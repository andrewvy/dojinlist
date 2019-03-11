defmodule Dojinlist.Repo.Migrations.AddTranscoderHashToTrack do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add(:transcoder_hash, :text)
    end

    create(index(:tracks, [:transcoder_hash]))
  end
end
