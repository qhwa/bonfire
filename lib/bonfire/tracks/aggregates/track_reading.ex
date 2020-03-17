defmodule Bonfire.Tracks.Aggregates.TrackReading do
  @moduledoc false

  defstruct [:track_id, :state]

  alias Bonfire.Tracks.{
    Events.ReadingStarted,
    Events.ReadingFinished,
    Events.ReadingUntracked,
    Events.CheckedIn,
    Commands.StartReading,
    Commands.FinishReading,
    Commands.UntrackReading,
    Commands.Checkin
  }

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

  def execute(%{state: nil}, %UntrackReading{}) do
    {:error, :not_tracking}
  end

  def execute(_, %UntrackReading{track_id: track_id}) do
    %ReadingUntracked{track_id: track_id}
  end

  def execute(%{state: nil}, %Checkin{track_id: track_id} = cmd) do
    [
      %ReadingStarted{track_id: track_id},
      %CheckedIn{track_id: track_id}
    ]
  end

  def execute(_, %Checkin{} = cmd) do
    %{cmd | __struct__: CheckedIn}
  end

  def apply(_, %ReadingStarted{track_id: track_id}) do
    %__MODULE__{track_id: track_id, state: :reading}
  end

  def apply(state, %ReadingFinished{}) do
    %{state | state: :finished}
  end

  def apply(state, %ReadingUntracked{}) do
    %{state | state: nil}
  end

  def apply(state, %CheckedIn{}) do
    state
  end
end
