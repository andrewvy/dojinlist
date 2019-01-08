defmodule Dojinlist.Repo.Migrations.AddCurrencyToTransaction do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      remove :amount

      add :sub_total, :money_with_currency
      add :tax_total, :money_with_currency
      add :cut_total, :money_with_currency
    end
  end
end
