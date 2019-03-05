defmodule DojinlistWeb.Mutations.Checkout do
  use Absinthe.Schema.Notation

  object :checkout_mutations do
    field :checkout_album, :checkout_response do
      arg(:album_id, non_null(:id))
      arg(:token, non_null(:string))
      arg(:user_email, :string)

      middleware(Absinthe.Relay.Node.ParseIDs, album_id: :album)

      resolve(&checkout_album/2)
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
end
