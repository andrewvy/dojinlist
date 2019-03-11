defmodule Dojinlist.Payments.StripeTest do
  use Dojinlist.DataCase, async: true

  alias Dojinlist.Fixtures
  alias Dojinlist.Payments

  test "Cannot purchase album if not linked to a stripe account" do
    {:ok, album} =
      Fixtures.album(%{
        price: Money.from_integer(12_00, :jpy)
      })

    assert false == Payments.Stripe.recipient_payable?(album)
  end

  test "Can purchase album if it is linked to a stripe account" do
    {:ok, storefront} = Fixtures.storefront()

    {:ok, album} =
      Fixtures.album(%{
        price: Money.from_integer(12_00, :jpy),
        storefront_id: storefront.id
      })

    {:ok, _stripe_account} =
      Fixtures.stripe_account(%{
        user_id: storefront.creator_id
      })

    assert true == Payments.Stripe.recipient_payable?(album)
  end
end
