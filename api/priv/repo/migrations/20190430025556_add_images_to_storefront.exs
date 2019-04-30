defmodule Dojinlist.Repo.Migrations.AddImagesToStorefront do
  use Ecto.Migration

  def change do
    alter table(:storefronts) do
      add(:avatar_image, :text)
      add(:banner_image, :text)
    end
  end
end
