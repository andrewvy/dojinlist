defmodule Dojinlist.EventsTest do
  use Dojinlist.DataCase, async: true

  test "Can insert events" do
    assert {:ok, event} = Dojinlist.Fixtures.event()
  end

  test "Cannot insert events with the same name" do
    assert {:ok, event} = Dojinlist.Fixtures.event(%{name: "RTS 1"})
    assert {:error, changeset} = Dojinlist.Fixtures.event(%{name: "RTS 1"})
  end
end
