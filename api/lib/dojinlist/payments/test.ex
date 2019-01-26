defmodule Dojinlist.Payments.Test do
  @moduledoc """
  Test payments adapter for testing purposes.
  """

  alias Dojinlist.Repo
  alias Dojinlist.Schemas.Transaction

  def recipient_payable?(_album) do
    true
  end

  def perform_transaction(_album, totals, _token) do
    %Transaction{}
    |> Transaction.changeset(%{
      transaction_id: random_id(),
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

  def random_id() do
    :crypto.strong_rand_bytes(20) |> Base.url_encode64() |> binary_part(0, 20)
  end
end
