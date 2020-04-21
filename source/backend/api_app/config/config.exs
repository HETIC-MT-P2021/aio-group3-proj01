# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :api_app,
  ecto_repos: [ApiApp.Repo]

# Configures the endpoint
config :api_app, ApiAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "w1qiQMXkvdkPxGTvIFrvLbhYzijcGqYYqFdg9zXCZz3cSFqmSzjZA9APWSGsCfKI",
  render_errors: [view: ApiAppWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ApiApp.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "Ojr/sYL8"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use waffle for image handling
config :waffle,
       storage: Waffle.Storage.Local,
       storage_dir_prefix: "priv/waffle/private",
       asset_host: "http://loclhost:4000"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
