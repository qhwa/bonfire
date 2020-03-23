defmodule BonfireWeb.Plug.PreloadProfile do
  @moduledoc """
  This module is used to preload profiles of users
  """

  alias Bonfire.Users.User

  import Plug.Conn

  def init(opts), do: opts

  def call(%{assigns: %{current_user: %User{} = user}} = conn, _opts) do
    conn
    |> assign(:current_user, Bonfire.Repo.preload(user, :profile))
  end

  def call(conn, _), do: conn
end
