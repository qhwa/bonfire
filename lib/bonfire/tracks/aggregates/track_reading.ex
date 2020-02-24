defmodule Bonfire.Tracks.Aggregates.TrackReading do
  defstruct [:book_id, :track]

  alias Bonfire.Core
  alias Bonfire.Tracks.Events.ReadingStarted
  alias Bonfire.Tracks.Commands.StartReading

  def execute(%{track: %{state: :reading}}, %StartReading{}) do
    {:error, :already_reading}
  end

  def execute(_, %StartReading{book_id: book_id}) do
    %ReadingStarted{started_at: DateTime.utc_now(), book_id: book_id}
  end

  def apply(_, %ReadingStarted{book_id: book_id}) do
    %__MODULE__{book_id: book_id, track: Core.start_reading(book_id)}
  end
end
