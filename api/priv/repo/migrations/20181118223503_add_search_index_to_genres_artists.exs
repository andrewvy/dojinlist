defmodule Dojinlist.Repo.Migrations.AddSearchIndexToGenresArtists do
  use Ecto.Migration

  def up do
    execute("""
      CREATE INDEX artists_trgm_index
      ON artists USING gin (name gin_trgm_ops);
    """)

    execute("""
      CREATE INDEX genres_trgm_index
      ON genres USING gin (name gin_trgm_ops);
    """)
  end

  def down do
    execute("DROP INDEX artists_trgm_index")
    execute("DROP INDEX genres_trgm_index")
  end
end
