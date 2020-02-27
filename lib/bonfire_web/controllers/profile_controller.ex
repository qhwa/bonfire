defmodule BonfireWeb.ProfileController do
  use BonfireWeb, :controller

  def show(conn, %{"user_name" => user_name}) do
    render(conn, "show.html")
  end
end
