defmodule Bonfire.CoreTest do
  use ExUnit.Case

  alias Bonfire.Core
  alias Bonfire.Core.{Track, Book, Note}

  doctest Core

  test "plan a reading" do
    book = %Book{title: "SWITCH"}
    assert %Track{state: :pending, book: book} = Core.plan_reading(book)
  end

  test "start a reading" do
    book = %Book{title: "SWITCH"}
    assert %Track{state: :reading, book: book} = Core.start_reading(book)
  end

  test "add notes" do
    note = Note.new("awesome")

    track =
      start_reading("TEST")
      |> Core.add_note(note)

    assert track.notes == [note]
  end

  test "update reading state" do
    track =
      start_reading("TEST")
      |> Core.update_reading_state(at_page: 10, feeling: "great", foo: :bar)

    assert track.at_page == 10
    assert track.feeling == "great"
    refute Map.get(track, :foo)
  end

  test "finish reading" do
    track =
      start_reading("TEST")
      |> Core.finish_reading()

    assert track.state == :finished
  end

  defp start_reading(book_name) do
    %Book{title: book_name}
    |> Core.start_reading()
  end
end
