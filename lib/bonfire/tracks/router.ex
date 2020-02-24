defmodule Bonfire.Tracks.Router do
  use Commanded.Commands.Router

  alias Bonfire.Tracks.Commands.StartReading
  alias Bonfire.Tracks.Aggregates.TrackReading

  dispatch(StartReading, to: TrackReading, identity: :book_id)
end
