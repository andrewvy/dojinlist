defmodule Dojinlist.OrdersTest do
  use Dojinlist.DataCase

  alias Dojinlist.Orders.Totals

  test "Can calculate grand total" do
    totals =
      %{
        Totals.new("USD")
        | sub_total: Money.new(:usd, 800),
          tax_total: Money.new(:usd, 50),
          shipping_total: Money.new(:usd, 100)
      }
      |> Totals.calculate_grand_total()

    assert Money.equal?(totals.grand_total, Money.new(:usd, 800 + 50 + 100))
  end
end
