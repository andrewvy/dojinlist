defmodule Dojinlist.Payments.Stripe do
  alias Dojinlist.Repo
  alias Dojinlist.Schemas.Transaction

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
      # Stripe Payment Processor
      payment_processor_id: 1
    })
    |> Repo.insert()
  end

  def create_charge(totals, token) do
    with {:ok, grand_total} <- Money.add(totals.sub_total, totals.tax_total) do
      {currency, amount, _exponent, _fractional} =
        Money.to_integer_exp(grand_total) |> IO.inspect()

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
