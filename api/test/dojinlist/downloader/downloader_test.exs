defmodule Dojinlist.DownloaderTest do
  use Dojinlist.DataCase

  alias Dojinlist.Fixtures
  alias Dojinlist.Downloader
  alias Dojinlist.Repo

  alias Dojinlist.Schemas.{
    Transaction,
    PurchasedAlbum
  }

  test "Purchased album should be downloadable" do
    {:ok, user} = Fixtures.user()
    {:ok, album} = Fixtures.album()

    transaction =
      %Transaction{}
      |> Transaction.changeset(%{
        sub_total: Money.new(:usd, 0),
        tax_total: Money.new(:usd, 0),
        cut_total: Money.new(:usd, 0),
        shipping_total: Money.new(:usd, 0),
        grand_total: Money.new(:usd, 0),
        charged_total: Money.new(:usd, 0),
        transaction_id: "123w241212",
        payment_processor_id: 1
      })
      |> Repo.insert!()

    assert false == Downloader.able_to_download_album?(user, album)

    %PurchasedAlbum{}
    |> PurchasedAlbum.changeset(%{
      user_id: user.id,
      album_id: album.id,
      transaction_id: transaction.id
    })
    |> Repo.insert!()

    assert true == Downloader.able_to_download_album?(user, album)
  end

  test "Can download track if album is purchased" do
    {:ok, user} = Fixtures.user()
    {:ok, album} = Fixtures.album()
    {:ok, track} = Fixtures.track(%{album_id: album.id})

    transaction =
      %Transaction{}
      |> Transaction.changeset(%{
        sub_total: Money.new(:usd, 0),
        tax_total: Money.new(:usd, 0),
        cut_total: Money.new(:usd, 0),
        shipping_total: Money.new(:usd, 0),
        grand_total: Money.new(:usd, 0),
        charged_total: Money.new(:usd, 0),
        transaction_id: "123w241212",
        payment_processor_id: 1
      })
      |> Repo.insert!()

    assert false == Downloader.able_to_download_track?(user, track)

    %PurchasedAlbum{}
    |> PurchasedAlbum.changeset(%{
      user_id: user.id,
      album_id: album.id,
      transaction_id: transaction.id
    })
    |> Repo.insert!()

    assert true == Downloader.able_to_download_track?(user, track)
  end

  test "Can download a track if provided a whitelisted encoding" do
    {:ok, user} = Fixtures.user()
    {:ok, album} = Fixtures.album()
    {:ok, track} = Fixtures.track(%{album_id: album.id})

    assert false == Downloader.able_to_download_track?(user, track)
    assert true == Downloader.able_to_download_track?(user, track, "mp3-128")
  end
end
