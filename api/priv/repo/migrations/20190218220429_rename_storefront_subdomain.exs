defmodule Dojinlist.Repo.Migrations.RenameStorefrontSubdomain do
  use Ecto.Migration

  def change do
    rename(table(:storefronts), :subdomain, to: :slug)
  end
end
