defmodule DojinlistWeb.Mutations.Checkout do
  use Absinthe.Schema.Notation

  object :checkout_mutations do
    field :calculate_totals_for_album, :cart_totals_response do
      arg(:album_id, non_null(:id))
      arg(:country, :string)
      arg(:state, :string)
      arg(:postal_code, :string)

      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)

      resolve(&calculate_totals_for_album/2)
    end
  end

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
             %{
               error_code: "ALBUM_NOT_FOUND",
               error_message: "Album was not found"
             }
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
