defmodule Dojinlist.Repo.Migrations.AddIndexToEvents do
  use Ecto.Migration

  def up do
    execute("""
      CREATE INDEX events_trgm_index
      ON events USING gin (name gin_trgm_ops);
    """)
  end

  def down do
    execute("DROP INDEX events_trgm_index")
  end
end
