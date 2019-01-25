defmodule Dojinlist.Payments.Stripe do
  alias Dojinlist.Repo
  alias Dojinlist.Storefront
  alias Dojinlist.OAuth
  alias Dojinlist.Schemas.Transaction

  def recipient_payable?(album) do
    # In order for a recipient (artist) to be paid, their user account needs
    # to have a stripe account assigned.
    case get_stripe_account_from_album(album) do
      nil -> false
      _ -> true
    end
  end

  def get_stripe_account_from_album(album) do
    with storefront <- Storefront.by_id(album.storefront_id) |> Repo.preload([:creator]),
         false <- storefront == nil,
         false <- storefront.creator == nil,
         stripe_account <- OAuth.Stripe.get_stripe_account_for_user(storefront.creator),
         false <- stripe_account == nil do
      stripe_account
    else
      _ -> nil
    end
  end

  def perform_transaction(totals, token) do
    with {:ok, charge} <- create_charge(totals, token),
         {:ok, transaction} <- create_transaction_from_charge(totals, charge) do
      {:ok, transaction}
    else
      {:error, %Stripe.Error{} = error} ->
        {:error, error}

      error ->
        error
    end
  end

  def create_transaction_from_charge(totals, charge) do
    %Transaction{}
    |> Transaction.changeset(%{
      transaction_id: charge.id,
      sub_total: totals.sub_total,
      tax_total: totals.tax_total,
      cut_total: totals.cut_total,
      shipping_total: totals.shipping_total,
      grand_total: totals.grand_total,
      charged_total: totals.charged_total,
      # Stripe Payment Processor
      payment_processor_id: 1
    })
    |> Repo.insert()
  end

  def create_charge(totals, token) do
    with {:ok, grand_total} <- Money.add(totals.sub_total, totals.tax_total) do
      {currency, amount, _exponent, _fractional} = Money.to_integer_exp(grand_total)

      Stripe.Charge.create(%{
        amount: amount,
        currency: to_string(currency),
        source: token
      })
    else
      _ ->
        {:error, "Totals are not all in the same currency!"}
    end
  end
end
