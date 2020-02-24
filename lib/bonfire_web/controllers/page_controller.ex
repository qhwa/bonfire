defmodule BonfireWeb.PageController do
  use BonfireWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
