defmodule Bonfire.Tracks.EventApp do
  use Commanded.Application,
    otp_app: :bonfire,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Bonfire.Tracks.EventStore
    ]

  router(Bonfire.Tracks.Router)
end
