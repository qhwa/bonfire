defmodule Bonfire.EventHandler do
  use Commanded.Event.Handler,
    application: Bonfire.EventApp,
    name: "BonfireEventHandler"

  alias Bonfire.Events.ReadingStarted

  def handle(%ReadingStarted{} = event, _metadata) do
    :ok
  end

  def handle(_event, _metadata) do
    :ok
  end
end
