defmodule Dojinlist.Payments.Totals do
  @moduledoc """
  This struct holds the totals that will be passed into creating
  charges/payments/transactions.
  """

  defstruct [
    :sub_total,
    :tax_total,
    :cut_total,
    :shipping_total,
    :grand_total,
    :charged_total
  ]
end
