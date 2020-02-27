defmodule Bonfire.EventRouter do
  use Commanded.Commands.CompositeRouter

  router(Bonfire.Tracks.Router)
  router(Bonfire.Sharing.Router)
end
