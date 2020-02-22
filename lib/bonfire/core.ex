defmodule Bonfire.Core do
  @moduledoc """
  This module holds the highest logics.
  """

  alias Bonfire.Core.{Book, Track}

  def plan_reading(%Book{} = book) do
    %Track{book: book, state: :pending}
  end

  def start_reading(book) do
    %Track{book: book, state: :reading}
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
