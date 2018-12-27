defmodule Dojinlist.Repo.Migrations.AddStorefronts do
  use Ecto.Migration

  def change do
    create table(:storefronts) do
      add :creator_id, references(:users)
      add :subdomain, :text

      timestamps()
    end

    create unique_index(:storefronts, [:subdomain])

    alter table(:albums) do
      add :storefront_id, references(:storefronts)
    end
  end
end
