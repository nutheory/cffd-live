defmodule CffdLive.Repo do
  use Ecto.Repo,
    otp_app: :cffd_live,
    adapter: Ecto.Adapters.Postgres
end
