defmodule CffdLiveWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :cffd_live

  socket "/socket", CffdLiveWeb.UserSocket,
    websocket: [timeout: 45_000],
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [timeout: 45_000]
  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :cffd_live,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  plug(Plug.Static, at: "/css/images", from: {:cffd_live, "priv/static/images"})
  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_cffd_live_key",
    signing_salt: "mg6BAte4"

  plug CORSPlug,
    origin: ["http://localhost:4000", "https://cffd-live.herokuapp.com", "https://live.cffd.ink"]

  plug CffdLiveWeb.Router
end
