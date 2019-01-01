defmodule Dojinlist.Repo.Migrations.AddTransactions do
  use Ecto.Migration

  def change do
    create table(:payment_processors) do
      add :name, :text
    end

    create table(:transactions) do
      add :transaction_id, :text
      add :amount, :integer

      add :payment_processor_id, references(:payment_processors)

      timestamps()
    end

    create table(:purchased_albums) do
      add :user_id, references(:users)
      add :transaction_id, references(:transactions)
      add :album_id, references(:albums)

      timestamps()
    end
  end
end
