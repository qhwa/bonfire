defmodule Bonfire.Tracks.Projectors.ReadingState do
  alias Bonfire.Books
  alias Bonfire.Tracks.Events.{ReadingStarted, ReadingFinished}
  alias Bonfire.Tracks.Schemas.ReadingState

  use Commanded.Projections.Ecto,
    application: Bonfire.EventApp,
    repo: Bonfire.Repo,
    name: "reading_state_projection",
    consistency: :strong

  project(%ReadingStarted{isbn: isbn}, %{created_at: created_at}, fn multi ->
    with {:ok, %{id: book_id, user_id: user_id}} <- Books.isbn_to_book(isbn) do
      reading_state = %ReadingState{
        book_id: book_id,
        user_id: user_id,
        state: "reading",
        started_at: DateTime.truncate(created_at, :second)
      }

      Ecto.Multi.insert(
        multi,
        :reading_started_projection,
        reading_state
      )
    end
  end)

  project(%ReadingFinished{isbn: isbn}, %{created_at: created_at}, fn multi ->
    rs =
      isbn
      |> Bonfire.Tracks.get_reading_state_by_isbn()
      |> ReadingState.updating_changeset(%{
        state: "finished",
        started_at: DateTime.truncate(created_at, :second)
      })

    Ecto.Multi.update(
      multi,
      :reading_finished_projection,
      rs
    )
  end)
end
