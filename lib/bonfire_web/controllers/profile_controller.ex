defmodule BonfireWeb.ProfileController do
  use BonfireWeb, :controller

  action_fallback BonfireWeb.FallbackController

  def show(conn, %{"user_name" => user_name}) do
    with {:ok, reading_states} <- Bonfire.Sharing.get_reading_states_by_profile(user_name) do
      render(conn, "show.html", reading_states: reading_states)
    end
  end
end
