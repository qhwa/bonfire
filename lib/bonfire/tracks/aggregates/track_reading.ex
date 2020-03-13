defmodule Bonfire.Tracks.Aggregates.TrackReading do
  @moduledoc false

  defstruct [:track_id, :state]

  alias Bonfire.Tracks.Events.ReadingStarted
  alias Bonfire.Tracks.Events.ReadingFinished
  alias Bonfire.Tracks.Commands.StartReading
  alias Bonfire.Tracks.Commands.FinishReading

  def execute(%{state: :reading}, %StartReading{}) do
    {:error, :already_reading}
  end

  def execute(_, %StartReading{track_id: track_id}) do
    %ReadingStarted{track_id: track_id}
  end

  def execute(%{state: :finished}, %FinishReading{}) do
    {:error, :already_finished}
  end

  def execute(_, %FinishReading{track_id: track_id}) do
    %ReadingFinished{track_id: track_id}
  end

  def apply(_, %ReadingStarted{track_id: track_id}) do
    %__MODULE__{track_id: track_id, state: :reading}
  end

  def apply(state, %ReadingFinished{}) do
    %{state | state: :finished}
  end
end
