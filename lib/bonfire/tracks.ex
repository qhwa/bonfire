defmodule Bonfire.Tracks do
  @moduledoc """
  Tracks context. This module holds tracking related high level API.
  """

  alias Bonfire.Books.{Book, Metadata}
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
    |> Repo.preload(book: [:metadata])
  end

  @doc """
  Gets a single reading_state.

  Raises if the Reading state does not exist.

  ## Examples

      iex> get_reading_state!(123)
      %ReadingState{}

  """
  def get_reading_state!(id),
    do: Repo.get!(ReadingState, id) |> Repo.preload(book: [:metadata])

  def get_reading_state_by_isbn(%{isbn: isbn, user_id: user_id}) do
    query =
      from(
        rs in ReadingState,
        join: book in Book,
        on: rs.book_id == book.id,
        join: info in Metadata,
        on: book.metadata_id == info.id,
        where: info.isbn == ^isbn,
        where: book.user_id == ^user_id
      )

    Repo.one(query)
  end

  def create_reading_state(%{"isbn" => isbn, "user_id" => user_id}) do
    EventApp.dispatch(%StartReading{isbn: %IsbnId{isbn: isbn, user_id: user_id}})
  end

  def finish_reading_state(isbn, user_id) do
    EventApp.dispatch(
      %FinishReading{isbn: %IsbnId{isbn: isbn, user_id: user_id}},
      consistency: :strong
    )
  end

  def delete_reading_state(_isbn) do
    raise "TODO"
  end
end
