defmodule Dojinlist.Tax do
  # @todo(vy): Pass in address all the way into here for sales tax total calcuation.
  def calculate_sales_tax(address, totals, products) do
    adapter_calculate(address, totals, products) || Money.from_integer(0, totals.currency_code)
  end

  def record_transaction(transaction, address, products) do
    adapter_record_transaction(transaction, address, products)
  end

  defp adapter_calculate(address, totals, products) do
    adapter = get_tax_adapter()
    adapter.calculate_sales_tax(address, totals, products)
  end

  defp adapter_record_transaction(transaction, address, products) do
    adapter = get_tax_adapter()
    adapter.record_transaction(transaction, address, products)
  end

  def get_tax_adapter() do
    Application.get_env(:dojinlist, :tax_adapter, Dojinlist.Tax.TestAdapter)
  end
end
