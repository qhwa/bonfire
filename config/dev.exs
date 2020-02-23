use Mix.Config

config :bonfire, Bonfire.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "bonfire_eventstore_dev",
  hostname: "localhost",
  pool_size: 10
