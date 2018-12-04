defmodule Dojinlist.Accounts do
  alias Dojinlist.Schemas.User
  alias Dojinlist.Repo

  import Ecto.Query

  def get_user(id) do
    User
    |> preload([:permissions])
    |> Repo.get(id)
  end

  def get_user_by_email(email) do
    User
    |> where(email: ^email)
    |> preload([:permissions])
    |> Repo.one()
  end

  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        send_confirmation_email(user)

      error ->
        error
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def send_confirmation_email(%User{} = user) do
    confirmation_token = Phoenix.Token.sign(DojinlistWeb.Endpoint, email_salt(), user.id)

    attrs = %{
      confirmed_at: nil,
      confirmation_token: confirmation_token,
      confirmation_sent_at: DateTime.utc_now()
    }

    case update_user(user, attrs) do
      {:ok, user} ->
        user
        |> Dojinlist.Emails.confirmation_email()
        |> Dojinlist.Mailer.deliver()

        {:ok, user}

      {:error, _} ->
        {:error, :could_not_send_email}
    end
  end

  def confirm_email_by_token(token) do
    with {:ok, user_id} <- verify_confirmation_token(token),
         user when not is_nil(user) <- get_user(user_id) do
      attrs = %{
        confirmed_at: DateTime.utc_now()
      }

      case update_user(user, attrs) do
        {:ok, user} -> {:ok, user}
        _ -> {:error, "Could not update user"}
      end
    else
      _ -> {:error, "Invalid token"}
    end
  end

  @spec verify_confirmation_token(String.t()) :: {:ok, any()} | {:error, atom()}
  def verify_confirmation_token(token) do
    Phoenix.Token.verify(DojinlistWeb.Endpoint, email_salt(), token, max_age: 86400)
  end

  def email_salt(), do: "email_salt_to_be_changed"
end
