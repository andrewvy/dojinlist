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

    field :checkout_album, :checkout_response do
      arg(:album_id, non_null(:id))
      arg(:token, non_null(:string))
      arg(:user_email, :string)

      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)

      resolve(&checkout_album/2)
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

  def checkout_album(%{album_id: album_id, user_email: user_email, token: token}, _) do
    case Dojinlist.Albums.get_album(album_id) do
      nil ->
        {:ok,
         %{
           errors: [
             DojinlistWeb.Errors.album_not_found()
           ]
         }}

      album ->
        Dojinlist.Payments.purchase_album_with_email(user_email, album, token)
        |> case do
          {:ok, _} ->
            {:ok, %{}}

          {:error, {:already_purchased, _}} ->
            {:ok,
             %{
               errors: [
                 DojinlistWeb.Errors.checkout_already_purchased()
               ]
             }}

          {:error, {:not_configured, _}} ->
            {:ok,
             %{
               errors: [
                 DojinlistWeb.Errors.checkout_not_configured()
               ]
             }}

          {:error, _} ->
            {:ok,
             %{
               errors: [
                 DojinlistWeb.Errors.checkout_failed()
               ]
             }}
        end
    end
  end

  def checkout_album(%{album_id: album_id, token: token}, %{context: %{current_user: user}}) do
    case Dojinlist.Albums.get_album(album_id) do
      nil ->
        {:ok,
         %{
           errors: [
             DojinlistWeb.Errors.album_not_found()
           ]
         }}

      album ->
        Dojinlist.Payments.purchase_album_with_account(user, album, token)
        |> case do
          {:ok, _} ->
            {:ok, %{}}

          {:error, {:already_purchased, _}} ->
            {:ok,
             %{
               errors: [
                 DojinlistWeb.Errors.checkout_already_purchased()
               ]
             }}

          {:error, {:not_configured, _}} ->
            {:ok,
             %{
               errors: [
                 DojinlistWeb.Errors.checkout_not_configured()
               ]
             }}

          {:error, _} ->
            {:ok,
             %{
               errors: [
                 DojinlistWeb.Errors.checkout_failed()
               ]
             }}
        end
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
