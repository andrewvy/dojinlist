defmodule Dojinlist.Fixtures do
  alias Dojinlist.Repo

  def user(attrs \\ %{}) do
    default_attrs = %{
      email: Faker.Internet.email(),
      username: Faker.Internet.user_name(),
      password: Faker.Lorem.sentence(),
      storefront: %{
        description: Faker.Lorem.sentence(),
        display_name: Faker.Internet.user_name(),
        location: Faker.Lorem.sentence()
      }
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
      title: Faker.Lorem.sentence(),
      price: Money.from_integer(800, :usd),
      slug: Faker.Internet.slug(Faker.Lorem.words(2..5), ["-"]),
      storefront_id:
        Map.get_lazy(attrs, :storefront_id, fn ->
          {:ok, user} = user()
          user.storefront_id
        end)
    }

    default_attrs
    |> Map.merge(attrs)
    |> Dojinlist.Albums.create_album()
  end

  def completed_album(attrs \\ %{}) do
    %{
      is_draft: false,
      status: "completed"
    }
    |> Map.merge(attrs)
    |> album()
  end

  def track(attrs \\ %{}) do
    default_attrs = %{
      title: Faker.Lorem.sentence(),
      play_length: 120,
      source_file: Faker.File.file_name(:audio),
      album_id:
        Map.get_lazy(attrs, :album_id, fn ->
          {:ok, album} = album()
          album.id
        end)
    }

    attrs =
      default_attrs
      |> Map.merge(attrs)

    Dojinlist.Tracks.create_track(attrs.album_id, attrs)
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

  def stripe_account(attrs \\ %{}) do
    default_attrs = %{
      user_id:
        Map.get_lazy(attrs, :user_id, fn ->
          {:ok, user} = user()
          user.id
        end),
      access_token: "access_token",
      scope: "all",
      livemode: true,
      refresh_token: "refresh_token",
      stripe_user_id: "stripe_user_id",
      stripe_publishable_key: "stripe_publishable_key"
    }

    attrs =
      default_attrs
      |> Map.merge(attrs)

    %Dojinlist.Schemas.StripeAccount{}
    |> Dojinlist.Schemas.StripeAccount.changeset(attrs)
    |> Repo.insert()
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

  def random_string() do
    :crypto.strong_rand_bytes(20) |> Base.url_encode64() |> binary_part(0, 20)
  end
end
