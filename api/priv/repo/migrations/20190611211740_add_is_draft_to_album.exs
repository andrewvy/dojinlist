defmodule Dojinlist.Repo.Migrations.AddIsDraftToAlbum do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add(:is_draft, :boolean, default: true)
    end
  end
end
