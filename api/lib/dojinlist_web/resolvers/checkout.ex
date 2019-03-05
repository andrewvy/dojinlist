defmodule DojinlistWeb.Resolvers.Checkout do
  def calculate_totals_for_album(%{album_id: album_id} = params, _) do
    address = %Dojinlist.Address{
      country: params[:country],
      state: params[:state],
      postal_code: params[:postal_code]
    }

    case Dojinlist.Albums.get_album(album_id) do
      nil ->
        {:ok,
         %{
           errors: [
             DojinlistWeb.Errors.album_not_found()
           ]
         }}

      album ->
        totals = Dojinlist.Orders.calculate_totals_for_album(address, album)

        {:ok,
         %{
           cart_totals: format_totals(totals)
         }}
    end
  end

  defp format_totals(totals) do
    %{
      sub_total: format_money(totals.sub_total),
      shipping_total: format_money(totals.shipping_total),
      tax_total: format_money(totals.tax_total),
      grand_total: format_money(totals.grand_total)
    }
  end

  defp format_money(money) do
    %{
      amount: Money.to_string!(money),
      currency: to_string(money.currency)
    }
  end
end
