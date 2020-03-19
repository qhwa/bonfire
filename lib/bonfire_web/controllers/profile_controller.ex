defmodule BonfireWeb.ProfileController do
  use BonfireWeb, :controller

  alias Bonfire.Sharing
  alias Bonfire.Sharing.Profile
  alias Bonfire.Tracks

  plug Pow.Plug.RequireAuthenticated,
       [error_handler: Pow.Phoenix.PlugErrorHandler] when action in [:edit]

  action_fallback BonfireWeb.FallbackController

  def show(conn, %{"user_name" => user_name}) do
    with {:ok, user_id, reading_states} <- Sharing.get_reading_states_by_profile(user_name),
         stats <- Tracks.stats(user_id) do
      conn
      |> put_layout("sharing.html")
      |> render("show.html", reading_states: reading_states, stats: stats)
    end
  end

  def edit(conn, _params) do
    with {:ok, profile} <- load_profile(conn.assigns.current_user) do
      render(conn, "edit.html", profile: Profile.updating_changeset(profile, %{}))
    end
  end

  defp load_profile(user) do
    Bonfire.Users.get_or_create_profile(user.id)
  end
end
