use Mix.Config

config :bonfire, Bonfire.Tracks.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "bonfire_eventstore_test",
  hostname: "localhost",
  pool_size: 10

# Configure your database
config :bonfire, Bonfire.Repo,
  username: "postgres",
  password: "postgres",
  database: "bonfire_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bonfire, BonfireWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
