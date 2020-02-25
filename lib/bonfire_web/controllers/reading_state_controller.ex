defmodule BonfireWeb.ReadingStateController do
  use BonfireWeb, :controller

  alias Bonfire.Tracks
  alias Bonfire.Tracks.Schemas.ReadingState

  def index(conn, _params) do
    reading_states = Tracks.list_reading_states()
    render(conn, "index.html", reading_states: reading_states)
  end

  def new(conn, _params) do
    changeset = Tracks.change_reading_state(%ReadingState{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"reading_state" => reading_state_params}) do
    case Tracks.create_reading_state(reading_state_params) do
      :ok ->
        conn
        |> put_flash(:info, "Reading state created successfully.")
        |> redirect(to: Routes.book_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reading_state = Tracks.get_reading_state!(id)
    render(conn, "show.html", reading_state: reading_state)
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
