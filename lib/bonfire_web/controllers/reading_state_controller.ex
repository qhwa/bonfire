defmodule BonfireWeb.ReadingStateController do
  use BonfireWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", stats: %{reading: 0, finished: 0})
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(conn, %{"id" => id}) do
    live_render(conn, BonfireWeb.Live.ReadingState, session: %{"id" => id})
  end
end
