use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cffd_live, CffdLiveWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :cffd_live, CffdLive.Repo,
  username: "postgres",
  password: "postgres",
  database: "cffd_live_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
