defmodule Dojinlist.Repo.Migrations.AddMetadataToStorefront do
  use Ecto.Migration

  def change do
    alter table(:storefronts) do
      add :description, :text
      add :display_name, :text
      add :location, :text
    end
  end
end
