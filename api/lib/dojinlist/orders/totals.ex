defmodule Dojinlist.Orders.Totals do
  alias Dojinlist.Address

  defstruct [
    :currency_code,
    :sub_total,
    :tax_total,
    :shipping_total,
    :grand_total,
    :cut_total,
    :charged_total
  ]

  def new(currency_code \\ "USD") do
    default_amount = Money.from_integer(0, currency_code)

    %__MODULE__{
      currency_code: currency_code,
      sub_total: default_amount,
      tax_total: default_amount,
      shipping_total: default_amount,
      grand_total: default_amount,
      cut_total: default_amount,
      charged_total: default_amount
    }
  end

  def set_sub_total(%__MODULE__{} = totals, sub_total) do
    %{
      totals
      | sub_total: sub_total
    }
  end

  def calculate_tax_total(%__MODULE__{} = totals, %Address{} = address, products) do
    # tax_total = Dojinlist.Tax.calculate_sales_tax(address, totals, products)

    # %{
    #   totals
    #   | tax_total: tax_total
    # }

    totals
  end

  def calculate_shipping_total(%__MODULE__{} = totals, %Address{} = _address) do
    totals
  end

  def calculate_cut_total(%__MODULE__{} = totals) do
    # 5% cut rate.
    percentage_rate = 0.05

    # $0.30 USD flat fee.
    flat_rate =
      if totals.currency_code == "USD" || totals.currency_code == :usd ||
           totals.currency_code == :USD do
        Money.from_integer(30, :usd)
      else
        Money.from_integer(30, :usd)
        |> Money.to_currency!(totals.currency_code)
      end

    fee_total =
      totals.sub_total
      |> Money.mult!(percentage_rate)
      |> Money.add!(flat_rate)

    cut_total =
      totals.sub_total
      |> Money.sub!(fee_total)

    %{
      totals
      | cut_total: cut_total
    }
  end

  def calculate_grand_total(%__MODULE__{} = totals) do
    default_amount = Money.from_integer(0, totals.currency_code)

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
