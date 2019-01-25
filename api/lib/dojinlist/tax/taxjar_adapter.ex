defmodule Dojinlist.Tax.TaxjarAdapter do
  alias Dojinlist.Hashid

  @digital_tax_code "31000"

  def calculate_sales_tax(address, totals, products) do
    order = %ExTaxjar.Order{
      to_country: address.country,
      to_state: address.state,
      to_zip: address.postal_code,
      shipping: to_decimal(totals.shipping_total),
      line_items: format_line_items(products)
    }

    ConCache.get_or_store(:tax_cache, order, fn ->
      response = ExTaxjar.Taxes.tax(order) || %{}
      amount_to_collect = response["amount_to_collect"] || 0.0

      Money.from_float(amount_to_collect, totals.currency_code)
    end)
  end

  def record_transaction(transaction, address, products) do
    %ExTaxjar.Transaction{
      transaction_id: transaction.id,
      transaction_date: transaction.created_at,
      to_country: address.country,
      to_state: address.state,
      to_zip: address.postal_code,
      sales_tax: to_decimal(transaction.tax_total),
      shipping: to_decimal(transaction.shipping_total),
      amount: to_decimal(Money.add!(transaction.sub_total, transaction.shipping_total)),
      line_items: format_line_items(products)
    }
    |> ExTaxjar.TransactionOrder.create()
  end

  defp format_line_items(products) do
    products
    |> Enum.map(&format_line_item/1)
  end

  defp format_line_item(product) do
    %{
      "id" => Hashid.encode(product.id),
      "quantity" => 1,
      "tax_code" => @digital_tax_code,
      "unit_price" => to_decimal(product.price)
    }
  end

  defp to_decimal(money) do
    money
    |> Money.to_decimal()
    |> Decimal.to_float()
  end
end
