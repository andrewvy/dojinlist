defmodule Dojinlist.AccountsTest do
  use Dojinlist.DataCase, async: true

  alias Dojinlist.Accounts

  test "Can register an account" do
    assert {:ok, account} =
             Accounts.register(%{
               username: "test",
               email: "test@local.com",
               password: "1234qwer"
             })

    refute account.storefront_id
  end

  test "Invalid fields prevent registration" do
    assert {:error, changeset} =
             Accounts.register(%{
               username: "test",
               email: "testlocal.com",
               password: "1234qwer"
             })
  end

  test "Can register as an artist account" do
    assert {:ok, account} =
             Accounts.register_artist(%{
               username: "test",
               email: "test@local.com",
               password: "1234qwer"
             })

    assert account.storefront_id
  end
end
