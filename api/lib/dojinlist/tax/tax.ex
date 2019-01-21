defmodule Dojinlist.Tax do
  # @todo(vy): Pass in address all the way into here for sales tax total calcuation.
  def calculate_sales_tax(address, totals, products) do
    adapter_calculate(address, totals, products)
  end

  defp adapter_calculate(address, totals, products) do
    adapter = get_payment_adapter()
    adapter.calculate_sales_tax(address, totals, products)
  end

  def get_payment_adapter() do
    Application.get_env(:dojinlist, :payment_adapter, Dojinlist.Payments.Test)
  end
end
