defmodule Dojinlist.Repo.Migrations.AddTotalsToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :shipping_total, :money_with_currency
      add :grand_total, :money_with_currency
      add :charged_total, :money_with_currency
    end
  end
end
