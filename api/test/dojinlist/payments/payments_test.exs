defmodule Dojinlist.PaymentsTest do
  use Dojinlist.DataCase

  alias Dojinlist.Fixtures
  alias Dojinlist.Payments

  test "Can purchase an album" do
    {:ok, user} = Fixtures.user()
    {:ok, album} = Fixtures.album()

    assert false == Dojinlist.Downloader.able_to_download_album?(user, album)

    {:ok, _purchased_album} = Payments.purchase_album(user, album, "tok_visa")

    assert true == Dojinlist.Downloader.able_to_download_album?(user, album)
  end
end
