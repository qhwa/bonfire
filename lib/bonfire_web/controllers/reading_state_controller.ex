defmodule BonfireWeb.ReadingStateController do
  use BonfireWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(conn, %{"id" => id}) do
    live_render(conn, BonfireWeb.Live.ReadingState, session: %{"id" => id})
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- Bonfire.Tracks.untrack_reading_state(id, conn.assigns.current_user.id) do
      conn
      |> put_flash(:info, "Successfully untracked.")
      |> redirect(to: Routes.reading_state_path(conn, :index))
    end
  end
end
