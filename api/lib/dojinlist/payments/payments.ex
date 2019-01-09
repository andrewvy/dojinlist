defmodule Dojinlist.Payments do
  alias Dojinlist.Repo
  alias Dojinlist.Schemas.PurchasedAlbum

  def test_totals() do
    %Dojinlist.Payments.Totals{
      sub_total: Money.from_integer(8_00, :usd),
      tax_total: Money.from_integer(0, :usd),
      cut_total: Money.from_integer(7_50, :usd)
    }
  end

  def purchase_album(user, album, token) do
    adapter = get_payment_adapter()
    totals = test_totals()

    adapter.perform_transaction(totals, token)
    |> case do
      {:ok, transaction} ->
        %PurchasedAlbum{}
        |> PurchasedAlbum.changeset(%{
          user_id: user.id,
          album_id: album.id,
          transaction_id: transaction.id
        })
        |> Repo.insert()

      error ->
        error
    end
  end

  def get_payment_adapter() do
    Application.get_env(:dojinlist, :payment_adapter, Dojinlist.Payments.Test)
  end
end
