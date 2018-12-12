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
