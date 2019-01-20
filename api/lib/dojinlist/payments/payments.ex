defmodule Dojinlist.Payments do
  alias Dojinlist.Repo
  alias Dojinlist.Schemas.PurchasedAlbum

  def purchase_album_with_email(email, album, token) do
    adapter_purchase(album, token)
    |> case do
      {:ok, transaction} ->
        %PurchasedAlbum{}
        |> PurchasedAlbum.changeset(%{
          user_email: email,
          album_id: album.id,
          transaction_id: transaction.id
        })
        |> Repo.insert()
        |> case do
          {:ok, _} -> {:ok, transaction}
          error -> error
        end

      error ->
        error
    end
  end

  def purchase_album_with_account(user, album, token) do
    adapter_purchase(album, token)
    |> case do
      {:ok, transaction} ->
        %PurchasedAlbum{}
        |> PurchasedAlbum.changeset(%{
          user_id: user.id,
          album_id: album.id,
          transaction_id: transaction.id
        })
        |> Repo.insert()
        |> case do
          {:ok, _} -> {:ok, transaction}
          error -> error
        end

      error ->
        error
    end
  end

  # @todo(vy): Pass in address all the way into here for order total calcuation.
  defp adapter_purchase(album, token) do
    adapter = get_payment_adapter()

    totals = Dojinlist.Orders.calculate_totals_for_album(%Dojinlist.Address{}, album)

    adapter.perform_transaction(totals, token)
  end

  def get_payment_adapter() do
    Application.get_env(:dojinlist, :payment_adapter, Dojinlist.Payments.Test)
  end
end
