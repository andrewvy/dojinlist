defmodule Dojinlist.Repo.Migrations.AddStripeOauthAccount do
  use Ecto.Migration

  def change do
    create table(:stripe_accounts) do
      add :access_token, :text
      add :scope, :text
      add :livemode, :boolean
      add :refresh_token, :text
      add :stripe_user_id, :text
      add :stripe_publishable_key, :text
      add :user_id, references(:users)
    end

    create unique_index(:stripe_accounts, [:user_id])
  end
end
