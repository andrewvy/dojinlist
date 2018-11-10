defmodule Dojinlist.GenresTest do
  use Dojinlist.DataCase

  alias Dojinlist.Genres

  test "Can create new genre" do
    assert {:ok, genre} =
             Genres.create_genre(%{
               name: "Electronic"
             })
  end

  test "Cannot create duplicate genres" do
    assert {:ok, genre} =
             Genres.create_genre(%{
               name: "Electronic"
             })

    assert {:error, changeset} =
             Genres.create_genre(%{
               name: "Electronic"
             })
  end
end
