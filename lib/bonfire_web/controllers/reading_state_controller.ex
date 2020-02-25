defmodule BonfireWeb.ReadingStateController do
  use BonfireWeb, :controller

  alias Bonfire.Tracks

  def index(conn, _params) do
    reading_states = Tracks.list_reading_states()
    render(conn, "index.html", reading_states: reading_states)
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(conn, %{"id" => id}) do
    rs = Tracks.get_reading_state!(id)
    render(conn, "show.html", reading_state: rs, book: rs.book, info: rs.book.metadata)
  end

  def edit(conn, %{"id" => id}) do
    reading_state = Tracks.get_reading_state!(id)
    changeset = Tracks.change_reading_state(reading_state)
    render(conn, "edit.html", reading_state: reading_state, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reading_state" => reading_state_params}) do
    reading_state = Tracks.get_reading_state!(id)

    case Tracks.update_reading_state(reading_state, reading_state_params) do
      {:ok, reading_state} ->
        conn
        |> put_flash(:info, "Reading state updated successfully.")
        |> redirect(to: Routes.reading_state_path(conn, :show, reading_state))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", reading_state: reading_state, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reading_state = Tracks.get_reading_state!(id)
    {:ok, _reading_state} = Tracks.delete_reading_state(reading_state)

    conn
    |> put_flash(:info, "Reading state deleted successfully.")
    |> redirect(to: Routes.reading_state_path(conn, :index))
  end
end
