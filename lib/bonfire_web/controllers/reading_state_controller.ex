defmodule BonfireWeb.ReadingStateController do
  use BonfireWeb, :controller

  plug Pow.Plug.RequireAuthenticated,
    error_handler: Pow.Phoenix.PlugErrorHandler

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def show(conn, %{"id" => id}) do
    live_render(conn, BonfireWeb.Live.ReadingState, session: %{"id" => id})
  end
end
