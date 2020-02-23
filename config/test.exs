use Mix.Config

config :bonfire, Bonfire.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "bonfire_eventstore_test",
  hostname: "localhost",
  pool_size: 10
