defmodule DojinlistWeb.Mutations.DownloadTest do
  use DojinlistWeb.ConnCase

  alias Dojinlist.Repo
  alias Dojinlist.Fixtures

  alias Dojinlist.Schemas.{
    Transaction,
    PurchasedAlbum
  }

  test "Cannot download a non-purchased album" do
    query = """
    mutation GenerateDownloadLink($download: DownloadInput) {
      generateAlbumDownloadUrl(download: $download) {
        url
        errors {
          errorCode
          errorMessage
        }
      }
    }
    """

    {:ok, user} = Fixtures.user()
    {:ok, album} = Fixtures.album()

    album_id = Absinthe.Relay.Node.to_global_id(:album, album.id, DojinlistWeb.Schema)

    variables = %{
      download: %{
        album_id: album_id,
        encoding: "MP3_V0"
      }
    }

    response =
      build_conn()
      |> Fixtures.login_as(user)
      |> execute_graphql(query, variables)

    assert %{"data" => %{"generateAlbumDownloadUrl" => %{"url" => nil}}} = response

    assert %{
             "data" => %{
               "generateAlbumDownloadUrl" => %{
                 "errors" => [%{"errorCode" => "ALBUM_NOT_PURCHASED"}]
               }
             }
           } = response
  end

  test "Can download an album" do
    query = """
    mutation GenerateDownloadLink($download: DownloadInput) {
      generateAlbumDownloadUrl(download: $download) {
        url
        errors {
          errorCode
          errorMessage
        }
      }
    }
    """

    {:ok, user} = Fixtures.user()
    {:ok, album} = Fixtures.album()

    transaction =
      %Transaction{}
      |> Transaction.changeset(%{
        sub_total: Money.new(:usd, 0),
        tax_total: Money.new(:usd, 0),
        cut_total: Money.new(:usd, 0),
        transaction_id: "123w241212",
        payment_processor_id: 1
      })
      |> Repo.insert!()

    %PurchasedAlbum{}
    |> PurchasedAlbum.changeset(%{
      user_id: user.id,
      album_id: album.id,
      transaction_id: transaction.id
    })
    |> Repo.insert!()

    album_id = Absinthe.Relay.Node.to_global_id(:album, album.id, DojinlistWeb.Schema)

    variables = %{
      download: %{
        album_id: album_id,
        encoding: "MP3_V0"
      }
    }

    response =
      build_conn()
      |> Fixtures.login_as(user)
      |> execute_graphql(query, variables)

    assert %{"data" => %{"generateAlbumDownloadUrl" => %{"url" => _}}} = response
  end
end
