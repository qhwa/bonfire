defmodule Bonfire.Tracks do
  @moduledoc """
  Tracks context. This module holds tracking related high level API.
  """

  alias Bonfire.Users
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

  alias Bonfire.Tracks.Schemas.Checkin, as: CheckinSchema

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
    %{
      finished: count_reading_state_by_state(user_id, "finished"),
      reading: count_reading_state_by_state(user_id, "reading"),
      checkin_count: count_checkins(user_id)
    }
  end

  defp count_reading_state_by_state(user_id, state) do
    from(rs in ReadingState, where: rs.user_id == ^user_id and rs.state == ^state)
    |> Repo.aggregate(:count)
  end

  defp count_checkins(user_id) do
    from(c in CheckinSchema, where: c.user_id == ^user_id)
    |> Repo.aggregate(:count)
  end

  @doc """
  Create a checkin for a user.
  """
  def checkin(isbn, user_id, insight \\ nil) do
    EventApp.dispatch(
      %Checkin{track_id: %TrackId{user_id: user_id, isbn: isbn}, insight: insight},
      consistency: :strong
    )
  end

  @doc """
  Generate a weekly reporting calendar for a user.
  """
  def weekly_calendar(user_id) do
    today = DateTime.utc_now() |> DateTime.to_date()

    from(c in "checkins", select: [:id, :date], where: c.user_id == ^user_id)
    |> Repo.all()
    |> Enum.group_by(&to_week(&1.date, today))
  end

  defp to_week(date, beginning) do
    Date.diff(beginning, date)
    |> Integer.floor_div(7)
  end

  @default_recent_quantity 10

  @doc """
  Get recent checkins of a user
  """
  def recent_checkins(user_id) do
    from(c in CheckinSchema,
      where: c.user_id == ^user_id,
      limit: @default_recent_quantity,
      order_by: [desc: :inserted_at]
    )
    |> Repo.all()
    |> Repo.preload([:book])
  end

  @doc """
  Get recent checked books
  """
  def recent_checked_books(user_id, limit \\ @default_recent_quantity) do
    recent_checkins =
      from(c in CheckinSchema,
        distinct: c.book_id,
        order_by: [desc: c.inserted_at]
      )

    from(b in Book,
      join: c in subquery(recent_checkins),
      on: c.book_id == b.id,
      limit: ^limit,
      order_by: [desc: c.inserted_at]
    )
    |> Repo.all()
  end

  @doc """
  Checkin stats summary of a user.
  """
  def checkin_stats(user_id) do
    tz = Users.get_timezone(user_id)

    checkins =
      from(c in "checkins", select: [:inserted_at], where: c.user_id == ^user_id)
      |> Repo.all()
      |> Enum.map(fn %{inserted_at: time} ->
        db_time_to_user_time(time, tz)
        |> DateTime.to_date()
      end)

    count_by = fn count ->
      checkins
      |> Enum.group_by(&count.(&1))
      |> Enum.count()
    end

    today = DateTime.utc_now() |> to_user_local_time(tz) |> DateTime.to_date()

    start_of_the_week = today |> Date.add(1 - Date.day_of_week(today))

    %{
      total: length(checkins),
      perfect_week_count: count_by.(&to_week(&1, start_of_the_week)),
      perfect_day_count: count_by.(& &1)
    }
  end

  def get_checkins(%ReadingState{} = reading_state) do
    from(c in CheckinSchema,
      where: c.reading_state_id == ^reading_state.id,
      order_by: [desc: :inserted_at]
    )
    |> Repo.all()
    |> Repo.preload(:book)
  end

  @doc """
  Convert a Datetime from DB (without timezone info) into User local time (with timezone)
  """
  def db_time_to_user_time(time, tz) do
    time
    |> DateTime.from_naive!("Etc/UTC")
    |> to_user_local_time(tz)
  end

  defp to_user_local_time(time, nil),
    do: time

  defp to_user_local_time(time, "Etc/UTC"),
    do: time

  defp to_user_local_time(time, tz),
    do: time |> DateTime.shift_zone!(tz, Tzdata.TimeZoneDatabase)

  @doc """
  Given a user's id, return if he/she has already checked in today.
  """
  def checked_in_today?(user_id) do
    tz = Users.get_timezone(user_id)
    last_checkin_time(user_id) |> today?(tz)
  end

  defp last_checkin_time(user_id) do
    from(
      c in CheckinSchema,
      where: c.user_id == ^user_id,
      order_by: [desc: :id],
      limit: 1,
      select: [:inserted_at]
    )
    |> Repo.one()
    |> case do
      %{inserted_at: time} -> time
      _ -> nil
    end
  end

  defp today?(nil, _), do: false

  defp today?(db_time, tz) do
    today =
      DateTime.utc_now()
      |> to_user_local_time(tz)
      |> DateTime.to_date()

    db_time
    |> db_time_to_user_time(tz)
    |> DateTime.to_date()
    |> Kernel.==(today)
  end
end
