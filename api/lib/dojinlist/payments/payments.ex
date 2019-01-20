defmodule Dojinlist.Payments do
  alias Dojinlist.Repo
  alias Dojinlist.Schemas.PurchasedAlbum

  def fees(sub_total) do
    percentage_fee = Decimal.new("0.05")
    flat_fee = Money.from_integer(30, :usd)
    percentage = Money.mult!(sub_total, percentage_fee)

    Money.add!(percentage, flat_fee)
  end

  def purchase_album_with_email(email, album, token) do
    adapter_purchase(album, token)
    |> case do
      {:ok, transaction} ->
        %PurchasedAlbum{}
        |> PurchasedAlbum.changeset(%{
          user_email: email,
          album_id: album.id,
          transaction_id: transaction.id
        })
        |> Repo.insert()
        |> case do
          {:ok, _} -> {:ok, transaction}
          error -> error
        end

      error ->
        error
    end
  end

  def purchase_album_with_account(user, album, token) do
    adapter_purchase(album, token)
    |> case do
      {:ok, transaction} ->
        %PurchasedAlbum{}
        |> PurchasedAlbum.changeset(%{
          user_id: user.id,
          album_id: album.id,
          transaction_id: transaction.id
        })
        |> Repo.insert()
        |> case do
          {:ok, _} -> {:ok, transaction}
          error -> error
        end

      error ->
        error
    end
  end

  defp adapter_purchase(album, token) do
    adapter = get_payment_adapter()
    sub_total = album.price
    fee = fees(sub_total)

    totals =
      struct!(Dojinlist.Payments.Totals, %{
        sub_total: sub_total,
        tax_total: Money.from_integer(0, :usd),
        cut_total: Money.sub!(sub_total, fee),
        shipping_total: Money.from_integer(0, :usd),
        grand_total: Money.from_integer(0, :usd),
        charged_total: Money.from_integer(0, :usd)
      })

    adapter.perform_transaction(totals, token)
  end

  def get_payment_adapter() do
    Application.get_env(:dojinlist, :payment_adapter, Dojinlist.Payments.Test)
  end
end
