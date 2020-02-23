defmodule Bonfire.EventApp do
  use Commanded.Application,
    otp_app: :bonfire,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Bonfire.EventStore
    ]

  router(Bonfire.Router)
end
