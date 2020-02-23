use Mix.Config

# config :bonfire, Bonfire.EventApp,
#   event_store: [
#     adapter: Commanded.EventStore.Adapters.Extreme,
#     serializer: Commanded.Serialization.JsonSerializer,
#     stream_prefix: "bonfire",
#     extreme: [
#       db_type: :node,
#       host: "localhost",
#       port: 1113,
#       username: "admin",
#       password: "changeit",
#       reconnect_delay: 2_000,
#       max_attempts: :infinity
#     ]
#   ]

config :bonfire, event_stores: [Bonfire.EventStore]

import_config "#{Mix.env()}.exs"
