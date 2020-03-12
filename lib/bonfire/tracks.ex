defmodule Bonfire.Tracks do
  @moduledoc """
  Tracks context. This module holds tracking related high level API.
  """

  alias Bonfire.Books.{Book, UserBook}
  alias Bonfire.Repo
  alias Bonfire.EventApp

  alias Bonfire.Tracks.{
    Schemas.ReadingState,
    Commands.StartReading,
    Commands.FinishReading
  }

  import Ecto.Query, only: [from: 2]

  @doc """
  Returns the list of reading_states.

  ## Examples

      iex> list_reading_states(1)
      [%ReadingState{}, ...]

  """
  def list_reading_states(user_id, opts \\ []) do
    order_by = Keyword.get(opts, :order_by, desc: :updated_at)

    from(
      rs in ReadingState,
      where: rs.user_id == ^user_id,
      order_by: ^order_by
    )
    |> Repo.all()
    |> Repo.preload(user_book: [:book])
  end

  @doc """
  Gets a single reading_state.

  Raises if the Reading state does not exist.

  ## Examples

      iex> get_reading_state!(123)
      %ReadingState{}

  """
  def get_reading_state!(id),
    do: Repo.get!(ReadingState, id) |> Repo.preload(user_book: [:book])

  def get_reading_state_by_isbn(isbn, user_id) do
    query =
      from(
        rs in ReadingState,
        join: user_book in UserBook,
        on: rs.user_book_id == user_book.id,
        join: book in Book,
        on: user_book.book_id == book.id,
        where: book.isbn == ^isbn,
        where: user_book.user_id == ^user_id
      )

    Repo.one(query)
  end

  def create_reading_state(%{"isbn" => isbn, "user_id" => user_id}) do
    EventApp.dispatch(%StartReading{track_id: %TrackId{isbn: isbn, user_id: user_id}})
  end

  def finish_reading_state(isbn, user_id) do
    EventApp.dispatch(
      %FinishReading{track_id: %TrackId{isbn: isbn, user_id: user_id}},
      consistency: :strong
    )
  end

  def delete_reading_state(_isbn) do
    raise "TODO"
  end
end
