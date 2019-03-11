defmodule Dojinlist.ArtistsTest do
  use Dojinlist.DataCase, async: true

  alias Dojinlist.Artists

  test "Can create new artist" do
    assert {:ok, artist} =
             Artists.create_artist(%{
               name: "Sakuzyo"
             })
  end

  test "Cannot insert duplicate artists" do
    assert {:ok, artist} =
             Artists.create_artist(%{
               name: "Sakuzyo"
             })

    assert {:error, artist} =
             Artists.create_artist(%{
               name: "Sakuzyo"
             })
  end
end
