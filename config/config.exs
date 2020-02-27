# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bonfire,
  ecto_repos: [Bonfire.Repo]

# Configures the endpoint
config :bonfire, BonfireWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "RBt4Gr1SgcmFO7Tkuch73S8OyrqLJcApAetkTqd8ApUTMItP6knDbttVEaIZBKH+",
  render_errors: [view: BonfireWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Bonfire.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "1ct/on/h"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bonfire, event_stores: [Bonfire.EventStore]

config :bonfire, :pow,
  user: Bonfire.Users.User,
  repo: Bonfire.Repo,
  web_module: BonfireWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
