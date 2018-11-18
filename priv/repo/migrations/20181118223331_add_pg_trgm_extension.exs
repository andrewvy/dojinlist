defmodule Dojinlist.Repo.Migrations.AddPgTrgmExtension do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS \"pg_trgm\" WITH SCHEMA public;"
  end

  def down do
    execute "DROP EXTENSION \"pg_trgm\";"
  end
end
