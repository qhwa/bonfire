defmodule BonfireWeb.ProfileController do
  use BonfireWeb, :controller

  alias Bonfire.Users.User
  alias Bonfire.Sharing
  alias Bonfire.Sharing.Profile
  alias Bonfire.Tracks.Schemas.Checkin
  alias Bonfire.Users

  plug Pow.Plug.RequireAuthenticated,
       [error_handler: Pow.Phoenix.PlugErrorHandler] when action in [:edit, :update]

  plug :load_profile when action in [:edit, :update]

  action_fallback BonfireWeb.FallbackController

  def show(conn, %{"user_name" => user_name}) do
    with %User{} = user <- Sharing.get_user(user_name),
         %User{} = user <-
           Bonfire.Repo.preload(user, [
             [reading_states: [user_book: :book]],
             [checkins: {Checkin.recent(), :book}]
           ]) do
      conn
      |> put_layout("sharing.html")
      |> render("show.html",
        user: user,
        reading_states: user.reading_states,
        checkins: user.checkins
      )
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
