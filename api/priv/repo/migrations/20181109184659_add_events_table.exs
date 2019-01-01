defmodule Dojinlist.Repo.Migrations.AddEventsTable do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :uuid, :uuid, default: fragment("uuid_generate_v4()")
      add :name, :text
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
    end

    alter table(:albums) do
      add :event_id, references(:events, on_delete: :nothing)
    end

    create unique_index(:events, [:name])
  end
end
