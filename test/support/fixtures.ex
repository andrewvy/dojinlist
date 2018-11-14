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

  def album(attrs \\ %{}) do
    default_attrs = %{
      name: Faker.Lorem.sentence(),
      sample_url: Faker.Internet.url() <> "/sample.mp3",
      purchase_url: Faker.Internet.url() <> "/purchase"
    }

    default_attrs
    |> Map.merge(attrs)
    |> Dojinlist.Albums.create_album()
  end

  def event(attrs \\ %{}) do
    default_attrs = %{
      name: Faker.Lorem.sentence(),
      start_date: Faker.Date.backward(5),
      end_date: Faker.Date.forward(5)
    }

    default_attrs
    |> Map.merge(attrs)
    |> Dojinlist.Events.create_event()
  end
end
