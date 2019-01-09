defmodule Dojinlist.Repo.Migrations.AddPriceToAlbums do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :price, :money_with_currency
    end
  end
end
