defmodule Dojinlist.Fixtures do
  def user(attrs \\ %{}) do
    default_attrs = %{
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: Faker.Lorem.sentence()
    }

    default_attrs
    |> Map.merge(attrs)
    |> Dojinlist.Accounts.register()
  end
end
