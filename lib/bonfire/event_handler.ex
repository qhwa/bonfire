defmodule Bonfire.EventHandler do
  use Commanded.Event.Handler,
    application: Bonfire.EventApp,
    name: "BonfireEventHandler"

  alias Bonfire.Events.ReadingStarted

  def handle(%ReadingStarted{} = event, _metadata) do
    IO.inspect(event, label: :good_news)
    :ok
  end

  def handle(event, _metadata) do
    IO.inspect(event, label: :ingored_event)
    :ok
  end
end
