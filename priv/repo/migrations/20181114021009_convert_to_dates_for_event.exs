defmodule Dojinlist.Repo.Migrations.ConvertToDatesForEvent do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :start_date, :date
      modify :end_date, :date
    end
  end
end
