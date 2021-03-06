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
  pubsub_server: Bonfire.PubSub,
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
  web_module: BonfireWeb,
  routes_backend: BonfireWeb.PowRouter

config :bonfire, Bonfire.EventStore, serializer: Commanded.Serialization.JsonSerializer

config :bonfire, Bonfire.Books.GoogleBookAPI,
  proxy: System.get_env("BONFIRE_GOOGLE_BOOK_API_PROXY")

config :bonfire, Bonfire.Books.DoubanBookApi,
  proxy: System.get_env("BONFIRE_DOUBAN_BOOK_API_PROXY")

config :bonfire, Bonfire.Auth.HTTP, proxy: System.get_env("BONFIRE_AUTH_PROXY")

config :bonfire, :pow_assent,
  http_adapter: Bonfire.Auth.HTTP,
  user_identities_context: Bonfire.Users

import_config "appsignal.exs"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
