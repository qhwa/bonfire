defmodule Bonfire.Tracks.Router do
  use Commanded.Commands.Router

  alias Bonfire.Tracks.Commands.{StartReading, FinishReading}
  alias Bonfire.Tracks.Aggregates.TrackReading

  identify(TrackReading, by: :isbn, prefix: "reading-state-")
  dispatch([StartReading, FinishReading], to: TrackReading)
end
