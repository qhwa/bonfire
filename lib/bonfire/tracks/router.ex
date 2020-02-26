defmodule Bonfire.Tracks.Router do
  use Commanded.Commands.Router

  alias Bonfire.Tracks.Commands.{StartReading, FinishReading}
  alias Bonfire.Tracks.Aggregates.TrackReading

  dispatch([StartReading, FinishReading], to: TrackReading, identity: :isbn)
end
