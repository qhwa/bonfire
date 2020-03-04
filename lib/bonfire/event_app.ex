defmodule Bonfire.EventApp do
  @moduledoc false

  use Commanded.Application,
    otp_app: :bonfire,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Bonfire.EventStore
    ]

  router(Bonfire.EventRouter)
end
