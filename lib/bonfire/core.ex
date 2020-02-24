defmodule Bonfire.Core do
  @moduledoc """
  This module holds the highest logics.
  """

  alias Bonfire.Core.Track

  def plan_reading(book_id) do
    %Track{book_id: book_id, state: :pending}
  end

  def start_reading(book_id) do
    %Track{book_id: book_id, state: :reading}
  end

  def update_reading_state(track, state) do
    updates =
      state
      |> Enum.into(%{})
      |> Map.take([:at_page, :feeling])

    Map.merge(track, updates)
  end

  def add_note(%Track{notes: notes} = track, note) do
    %Track{track | notes: [note | notes]}
  end

  def finish_reading(track) do
    %Track{track | state: :finished}
  end
end
