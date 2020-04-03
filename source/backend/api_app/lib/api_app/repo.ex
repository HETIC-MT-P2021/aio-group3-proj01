defmodule ApiApp.Repo do
  use Ecto.Repo,
    otp_app: :api_app,
    adapter: Ecto.Adapters.Postgres
end
