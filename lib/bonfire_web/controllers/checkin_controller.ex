defmodule BonfireWeb.CheckinController do
  use BonfireWeb, :controller

  alias Bonfire.Tracks

  def index(conn, _params) do
    user_id = user_id(conn)
    calendar = Tracks.weekly_calendar(user_id)
    checkins = Tracks.recent_checkins(user_id)

    render(conn, "index.html", weekly_calendar: calendar, checkins: checkins)
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  defp user_id(conn) do
    conn.assigns.current_user.id
  end
end
