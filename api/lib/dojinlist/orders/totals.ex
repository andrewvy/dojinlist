defmodule Dojinlist.Orders.Totals do
  alias Dojinlist.Address

  defstruct [
    :currency_code,
    :sub_total,
    :tax_total,
    :shipping_total,
    :grand_total
  ]

  def new(currency_code \\ "USD") do
    default_amount = Money.new(currency_code, 0)

    %__MODULE__{
      currency_code: currency_code,
      sub_total: default_amount,
      tax_total: default_amount,
      shipping_total: default_amount,
      grand_total: default_amount
    }
  end

  def set_sub_total(%__MODULE__{} = totals, sub_total) do
    %{
      totals
      | sub_total: sub_total
    }
  end

  def calculate_tax_total(%__MODULE__{} = totals, %Address{} = _address) do
    # @todo(vy): Calculate tax.
    totals
  end

  def calculate_shipping_total(%__MODULE__{} = totals, %Address{} = _address) do
    totals
  end

  def calculate_grand_total(%__MODULE__{} = totals) do
    default_amount = Money.new(totals.currency_code, 0)

    grand_total =
      default_amount
      |> Money.add!(totals.sub_total)
      |> Money.add!(totals.tax_total)
      |> Money.add!(totals.shipping_total)

    %{
      totals
      | grand_total: grand_total
    }
  end
end
