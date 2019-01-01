defmodule Dojinlist.Repo.Migrations.AddAlbumsTable do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :uuid, :uuid, default: fragment("uuid_generate_v4()")
      add :name, :text
      add :sample_url, :text
      add :purchase_url, :text

      timestamps()
    end
  end
end
