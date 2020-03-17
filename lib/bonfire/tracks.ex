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
    Commands.FinishReading,
    Commands.UntrackReading,
    Commands.Checkin
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

      iex> get_reading_state(123, 1)
      {:ok, %ReadingState{}}

  """
  def get_reading_state(id, user_id) do
    from(rs in ReadingState, where: rs.id == ^id and rs.user_id == ^user_id)
    |> Repo.one()
    |> Repo.preload(user_book: [:book])
    |> case do
      %ReadingState{} = rs ->
        {:ok, rs}

      nil ->
        {:error, :not_found}
    end
  end

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
    |> Repo.preload(user_book: [:book])
  end

  def create_reading_state(%{"isbn" => isbn, "user_id" => user_id}) do
    create_reading_state(isbn, user_id)
  end

  def create_reading_state(isbn, user_id) do
    EventApp.dispatch(%StartReading{track_id: %TrackId{isbn: isbn, user_id: user_id}})
  end

  def finish_reading_state(isbn, user_id) do
    EventApp.dispatch(
      %FinishReading{track_id: %TrackId{isbn: isbn, user_id: user_id}},
      consistency: :strong
    )
  end

  def untrack_reading_state(id, user_id) do
    Repo.get_by(ReadingState, id: id, user_id: user_id)
    |> Repo.preload(user_book: [:book])
    |> case do
      %ReadingState{} = rs ->
        isbn = rs.user_book.book.isbn

        EventApp.dispatch(
          %UntrackReading{track_id: %TrackId{isbn: isbn, user_id: user_id}},
          consistency: :strong
        )

      nil ->
        {:error, :not_found}
    end
  end

  def stats(user_id) do
    count = fn state ->
      from(rs in ReadingState, where: rs.user_id == ^user_id and rs.state == ^state)
      |> Repo.aggregate(:count)
    end

    %{
      finished: count.("finished"),
      reading: count.("reading")
    }
  end

  def checkin(isbn, user_id) do
    EventApp.dispatch(%Checkin{track_id: %TrackId{user_id: user_id, isbn: isbn}})
  end
end
