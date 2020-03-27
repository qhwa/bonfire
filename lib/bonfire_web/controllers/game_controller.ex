defmodule BonfireWeb.GameController do
  use BonfireWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", games: Bonfire.Games.top_games())
  end
end
