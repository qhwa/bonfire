defmodule BonfireWeb.CheckinController do
  use BonfireWeb, :controller

  alias Bonfire.Tracks

  def index(conn, _params) do
    user_id = user_id(conn)
    stats = Tracks.checkin_stats(user_id)
    checkins = Tracks.recent_checkins(user_id)

    render(conn, "index.html", stats: stats, checkins: checkins)
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  defp user_id(conn) do
    conn.assigns.current_user.id
  end
end
