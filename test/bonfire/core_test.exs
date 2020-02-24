defmodule Bonfire.CoreTest do
  use ExUnit.Case

  alias Bonfire.Core
  alias Bonfire.Core.{Track, Note}

  doctest Core

  test "plan a reading" do
    book_id = 1
    assert %Track{state: :pending, book_id: book_id} = Core.plan_reading(book_id)
  end

  test "start a reading" do
    book_id = 1
    assert %Track{state: :reading, book_id: book_id} = Core.start_reading(book_id)
  end

  test "add notes" do
    note = Note.new("awesome")

    track =
      Core.start_reading(1)
      |> Core.add_note(note)

    assert track.notes == [note]
  end

  test "update reading state" do
    track =
      Core.start_reading(1)
      |> Core.update_reading_state(at_page: 10, feeling: "great", foo: :bar)

    assert track.at_page == 10
    assert track.feeling == "great"
    refute Map.get(track, :foo)
  end

  test "finish reading" do
    track =
      Core.start_reading(1)
      |> Core.finish_reading()

    assert track.state == :finished
  end
end
