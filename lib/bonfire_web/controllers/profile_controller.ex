defmodule BonfireWeb.ProfileController do
  use BonfireWeb, :controller

  alias Bonfire.Sharing
  alias Bonfire.Sharing.Profile
  alias Bonfire.Tracks
  alias Bonfire.Users

  plug Pow.Plug.RequireAuthenticated,
       [error_handler: Pow.Phoenix.PlugErrorHandler] when action in [:edit, :update]

  plug :load_profile when action in [:edit, :update]

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
    changeset = Profile.updating_changeset(conn.assigns.profile, %{})
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"profile" => params}) do
    changeset = Profile.updating_changeset(conn.assigns.profile, params)

    case Bonfire.Repo.update(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Successfully updated!")
        |> render("edit.html", changeset: changeset)

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Something went wrong!")
        |> render("edit.html", changeset: changeset)
    end
  end

  defp load_profile(conn, _) do
    Users.get_or_create_profile(conn.assigns.current_user.id)
    |> case do
      {:ok, profile} ->
        conn |> assign(:profile, profile)

      {:error, _} ->
        conn |> halt()
    end
  end
end
