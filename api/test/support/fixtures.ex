defmodule Dojinlist.Fixtures do
  alias Dojinlist.Repo

  def user(attrs \\ %{}) do
    default_attrs = %{
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: Faker.Lorem.sentence()
    }

    merged_attrs =
      default_attrs
      |> Map.merge(attrs)

    %Dojinlist.Schemas.User{}
    |> Dojinlist.Schemas.User.changeset(merged_attrs)
    |> Repo.insert()
  end

  def album(attrs \\ %{}) do
    default_attrs = %{
      japanese_title: Faker.Lorem.sentence(),
      sample_url: Faker.Internet.url() <> "/sample.mp3",
      purchase_url: Faker.Internet.url() <> "/purchase",
      storefront_id:
        Map.get_lazy(attrs, :storefront_id, fn ->
          {:ok, storefront} = storefront()
          storefront.id
        end)
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

  def storefront(attrs \\ %{}) do
    default_attrs = %{
      subdomain:
        Map.get_lazy(attrs, :subdomain, fn -> Faker.Lorem.word() |> String.downcase() end),
      creator_id:
        Map.get_lazy(attrs, :creator_id, fn ->
          {:ok, user} = user()
          user.id
        end)
    }

    default_attrs
    |> Dojinlist.Storefront.create_storefront()
  end

  def grant_all_permissions_to_user(user) do
    Dojinlist.Permissions.get_permissions()
    |> Enum.map(fn permission ->
      Dojinlist.Permissions.add_permission_to_user(user, permission.type)
    end)

    user
  end

  def login_as(conn, user) do
    token = Dojinlist.Authentication.generate_token(user.id)

    conn
    |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")
  end

  def create_and_login_as_admin(conn) do
    {:ok, user} = user()
    user = grant_all_permissions_to_user(user)

    conn
    |> login_as(user)
  end
end
