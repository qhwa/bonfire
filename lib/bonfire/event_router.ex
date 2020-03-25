defmodule Bonfire.EventRouter do
  @moduledoc false
  use Commanded.Commands.CompositeRouter

  router(Bonfire.Tracks.Router)
  router(Bonfire.Sharing.Router)
  router(Bonfire.Games.Router)
  router(Bonfire.Pushes.Router)
end
