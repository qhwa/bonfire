defmodule Bonfire.EventHandler do
  use Commanded.Event.Handler,
    application: Bonfire.EventApp,
    name: "BonfireEventHandler"

  alias Bonfire.Events.ReadingStarted

  def handle(%ReadingStarted{book_id: book_id}, _metadata) do
    Bonfire.Tracks.start_reading(book_id)
  end

  def handle(_event, _metadata) do
    :ok
  end
end
