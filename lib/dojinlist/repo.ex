defmodule Dojinlist.Repo do
  use Ecto.Repo,
    otp_app: :dojinlist,
    adapter: Ecto.Adapters.Postgres

  use Paginator
end
