defmodule Bonfire.Router do
  use Commanded.Commands.Router

  dispatch(Bonfire.Commands.StartReading, to: Bonfire.Aggregates.TrackReading, identity: :book_id)
end
