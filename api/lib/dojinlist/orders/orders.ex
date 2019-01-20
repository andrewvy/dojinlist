defmodule Dojinlist.Orders do
  alias Dojinlist.Orders.Totals
  alias Dojinlist.Address

  def calculate_totals_for_album(%Address{} = address, album) do
    currency_code = album.price.currency

    Totals.new(currency_code)
    |> Totals.set_sub_total(album.price)
    |> Totals.calculate_tax_total(address)
    |> Totals.calculate_shipping_total(address)
    |> Totals.calculate_grand_total()
  end
end
