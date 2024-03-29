defmodule DojinlistWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :dojinlist

  if Mix.env() == :dev do
    plug(Corsica,
      origins: ["http://localhost:3000", ~r{^http?://(.*\.?)dojinlist\.local:3000$}],
      log: [rejected: :error, invalid: :warn, accepted: :debug],
      allow_headers: ["content-type", "authorization"],
      allow_methods: :all,
      allow_credentials: true,
      max_age: 600
    )

    # Normally, this is handled through S3 on production.
    plug(Plug.Static, at: "/uploads", from: "uploads/", gzip: false)
  else
    plug(Corsica,
      origins: "*",
      allow_headers: ["content-type", "authorization"],
      log: [rejected: :error, invalid: :warn, accepted: :debug],
      allow_methods: :all,
      allow_credentials: true,
      max_age: 600
    )
  end

  socket("/socket", DojinlistWeb.UserSocket,
    websocket: true,
    longpoll: false
  )

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug(Plug.Static,
    at: "/",
    from: :dojinlist,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)
  )

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug(Phoenix.CodeReloader)
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    length: 1_000_000_000_000,
    json_decoder: Phoenix.json_library()
  )

  plug(Plug.MethodOverride)
  plug(Plug.Head)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug(Plug.Session,
    store: :cookie,
    key: "_dojinlist_key",
    signing_salt: "lbRJnq35"
  )

  plug(DojinlistWeb.Context)

  # When called directly:
  plug(Absinthe.Plug,
    schema: DojinlistWeb.Schema,
    json_codec: Jason
  )
end
