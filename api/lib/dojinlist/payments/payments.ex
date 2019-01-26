defmodule Dojinlist.Payments do
  alias Dojinlist.Repo

  alias Dojinlist.Schemas.{
    PurchasedAlbum,
    Transaction
  }

  def purchase_album_with_email(email, album, token) do
    if recipient_payable?(album) do
      transaction_result =
        if free_album?(album) do
          create_free_transaction(album.price.currency)
        else
          adapter_purchase(album, token)
        end

      transaction_result
      |> case do
        {:ok, transaction} ->
          record_purchased_album(%{user_email: email}, album, transaction)

        error ->
          error
      end
    else
      {:error, "Album not configured to be purchasable."}
    end
  end

  def purchase_album_with_account(user, album, token) do
    if recipient_payable?(album) do
      transaction_result =
        if free_album?(album) do
          create_free_transaction(album.price.currency)
        else
          adapter_purchase(album, token)
        end

      transaction_result
      |> case do
        {:ok, transaction} ->
          record_purchased_album(%{user_id: user.id}, album, transaction)

        error ->
          error
      end
    else
      {:error, "Album not configured to be purchasable."}
    end
  end

  def record_purchased_album(user_attrs, album, transaction) do
    attrs =
      Map.merge(user_attrs, %{
        album_id: album.id,
        transaction_id: transaction.id
      })

    %PurchasedAlbum{}
    |> PurchasedAlbum.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, _} -> {:ok, transaction}
      error -> error
    end
  end

  def create_free_transaction(currency_code) do
    attrs = %{
      transaction_id: "free",
      sub_total: Money.zero(currency_code),
      tax_total: Money.zero(currency_code),
      cut_total: Money.zero(currency_code),
      shipping_total: Money.zero(currency_code),
      grand_total: Money.zero(currency_code),
      charged_total: Money.zero(currency_code),
      payment_processor_id: 1
    }

    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def free_album?(album) do
    currency_code = album.price.currency
    zero = Money.zero(currency_code)

    Money.equal?(zero, album.price)
  end

  def recipient_payable?(album) do
    adapter = get_payment_adapter()
    adapter.recipient_payable?(album)
  end

  # @todo(vy): Pass in address all the way into here for order total calcuation.
  defp adapter_purchase(album, token) do
    adapter = get_payment_adapter()

    totals = Dojinlist.Orders.calculate_totals_for_album(%Dojinlist.Address{}, album)

    adapter.perform_transaction(album, totals, token)
  end

  def get_payment_adapter() do
    Application.get_env(:dojinlist, :payment_adapter, Dojinlist.Payments.Test)
  end
end
