defmodule BonfireWeb.ProfileController do
  use BonfireWeb, :controller

  action_fallback BonfireWeb.FallbackController

  def show(conn, %{"user_name" => user_name}) do
    with {:ok, profile} <- Bonfire.Sharing.get_profile(user_name) do
      render(conn, "show.html", reading_states: profile.user.reading_states)
    end
  end
end
