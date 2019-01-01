defmodule Dojinlist.Repo.Migrations.AddArtistsAndGenresTable do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :uuid, :uuid, default: fragment("uuid_generate_v4()")
      add :name, :text
    end

    create table(:genres) do
      add :uuid, :uuid, default: fragment("uuid_generate_v4()")
      add :name, :text
    end

    create table(:albums_artists) do
      add :album_id, references(:albums, on_delete: :delete_all)
      add :artist_id, references(:artists, on_delete: :delete_all)
    end

    create table(:albums_genres) do
      add :album_id, references(:albums, on_delete: :delete_all)
      add :genre_id, references(:genres, on_delete: :delete_all)
    end

    create unique_index(:artists, [:name])
    create unique_index(:genres, [:name])

    create unique_index(:albums_artists, [:album_id, :artist_id])
    create unique_index(:albums_genres, [:album_id, :genre_id])
  end
end
