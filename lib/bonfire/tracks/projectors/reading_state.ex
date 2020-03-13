defmodule Bonfire.Tracks.Projectors.ReadingState do
  @moduledoc """
  A projector with hooks on reading state related changes.
  """

  alias Bonfire.Books
  alias Bonfire.Tracks.Events.{ReadingStarted, ReadingFinished}
  alias Bonfire.Tracks.Schemas.ReadingState

  use Commanded.Projections.Ecto,
    application: Bonfire.EventApp,
    repo: Bonfire.Repo,
    name: "reading_state_projection",
    consistency: :strong

  project(
    %ReadingStarted{track_id: %{user_id: user_id, isbn: isbn}},
    %{created_at: created_at},
    fn multi ->
      with {:ok, %{id: user_book_id, user_id: user_id}} <- Books.isbn_to_user_book(isbn, user_id) do
        reading_state = %ReadingState{
          user_book_id: user_book_id,
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
    end
  )

  project(
    %ReadingFinished{track_id: %{user_id: user_id, isbn: isbn}},
    %{created_at: created_at},
    fn multi ->
      rs =
        Bonfire.Tracks.get_reading_state_by_isbn(isbn, user_id)
        |> ReadingState.updating_changeset(%{
          state: "finished",
          started_at: DateTime.truncate(created_at, :second)
        })

      ret =
        Ecto.Multi.update(
          multi,
          :reading_finished_projection,
          rs
        )

      Phoenix.PubSub.broadcast(
        Bonfire.PubSub,
        "rs:#{user_id}",
        {__MODULE__, :reading_state_updated, rs}
      )

      ret
    end
  )
end
