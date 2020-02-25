defmodule Bonfire.Tracks.Aggregates.TrackReading do
  defstruct [:isbn, :state]

  alias Bonfire.Tracks.Events.ReadingStarted
  alias Bonfire.Tracks.Commands.StartReading

  def execute(%{state: :reading}, %StartReading{}) do
    {:error, :already_reading}
  end

  def execute(_, %StartReading{isbn: isbn}) do
    %ReadingStarted{isbn: isbn}
  end

  def apply(_, %ReadingStarted{isbn: isbn}) do
    %__MODULE__{isbn: isbn, state: :reading}
  end
end
