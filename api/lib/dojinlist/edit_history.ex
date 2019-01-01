defmodule Dojinlist.EditHistory do
  alias Dojinlist.Repo
  alias Dojinlist.Schemas.AlbumEditHistory

  def new_album_edit(album_id, user_id, edit_type) do
    %AlbumEditHistory{}
    |> AlbumEditHistory.changeset(%{
      album_id: album_id,
      user_id: user_id,
      edit_type: edit_type
    })
    |> Repo.insert()
  end
end
