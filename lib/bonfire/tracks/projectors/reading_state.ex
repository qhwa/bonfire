defmodule Bonfire.Tracks.Projectors.ReadingState do
  alias Bonfire.Books
  alias Bonfire.Tracks.Events.ReadingStarted
  alias Bonfire.Tracks.Schemas.ReadingState

  use Commanded.Projections.Ecto,
    application: Bonfire.Tracks.EventApp,
    repo: Bonfire.Repo,
    name: "reading_state_projection"

  project(%ReadingStarted{isbn: isbn}, %{created_at: created_at}, fn multi ->
    {:ok, %{id: book_id}} = Books.isbn_to_book(isbn)

    reading_state = %ReadingState{
      book_id: book_id,
      state: "started",
      started_at: DateTime.truncate(created_at, :second)
    }

    Ecto.Multi.insert(
      multi,
      :reading_started_projection,
      reading_state
    )
  end)
end
