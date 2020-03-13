defmodule BonfireWeb.ProfileController do
  use BonfireWeb, :controller

  alias Bonfire.Sharing
  alias Bonfire.Tracks

  action_fallback BonfireWeb.FallbackController

  def show(conn, %{"user_name" => user_name}) do
    with {:ok, user_id, reading_states} <- Sharing.get_reading_states_by_profile(user_name),
         stats <- Tracks.stats(user_id) do
      conn
      |> put_layout("sharing.html")
      |> render("show.html", reading_states: reading_states, stats: stats)
    end
  end
end
