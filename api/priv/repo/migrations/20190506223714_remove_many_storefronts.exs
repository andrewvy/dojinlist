defmodule Dojinlist.Repo.Migrations.RemoveManyStorefronts do
  use Ecto.Migration

  def up do
    alter table(:storefronts) do
      remove(:creator_id)
      remove(:slug)
    end

    alter table(:users) do
      add(:storefront_id, references(:storefronts))
    end
  end

  def down do
    alter table(:storefronts) do
      add(:creator_id, references(:users))
      add(:slug, :text)
    end

    alter table(:users) do
      remove(:storefront_id)
    end
  end
end
