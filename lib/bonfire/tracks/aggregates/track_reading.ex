defmodule Bonfire.Tracks.Aggregates.TrackReading do
  defstruct [:isbn, :state]

  alias Bonfire.Tracks.Events.ReadingStarted
  alias Bonfire.Tracks.Events.ReadingFinished
  alias Bonfire.Tracks.Commands.StartReading
  alias Bonfire.Tracks.Commands.FinishReading

  def execute(%{state: :reading}, %StartReading{}) do
    {:error, :already_reading}
  end

  def execute(_, %StartReading{isbn: isbn}) do
    %ReadingStarted{isbn: isbn}
  end

  def execute(%{state: :finished} = state, %FinishReading{}) do
    {:error, :already_finished}
  end

  def execute(_, %FinishReading{isbn: isbn}) do
    %ReadingFinished{isbn: isbn}
  end

  def apply(_, %ReadingStarted{isbn: isbn}) do
    %__MODULE__{isbn: isbn, state: :reading}
  end

  def apply(state, %ReadingFinished{}) do
    %{state | state: :finished}
  end
end
