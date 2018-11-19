defmodule Dojinlist.Repo.Migrations.AddEditHistoryTable do
  use Ecto.Migration

  def change do
    create table(:albums_edit_history) do
      add :album_id, references(:albums, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
      add :edit_type, :text

      timestamps()
    end
  end
end
