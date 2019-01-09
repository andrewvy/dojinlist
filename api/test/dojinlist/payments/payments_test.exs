defmodule Dojinlist.PaymentsTest do
  use Dojinlist.DataCase

  alias Dojinlist.Fixtures
  alias Dojinlist.Payments

  test "Can purchase an album" do
    {:ok, user} = Fixtures.user()

    {:ok, album} =
      Fixtures.album(%{
        price: Money.from_integer(12_00, :usd)
      })

    assert false == Dojinlist.Downloader.able_to_download_album?(user, album)

    {:ok, transaction} = Payments.purchase_album(user, album, "tok_visa")

    assert Money.equal?(transaction.sub_total, album.price)

    fee = Payments.fees(album.price)
    cut = Money.sub!(album.price, fee)

    assert Money.equal?(transaction.cut_total, cut)

    assert true == Dojinlist.Downloader.able_to_download_album?(user, album)
  end
end
