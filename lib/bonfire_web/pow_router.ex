defmodule BonfireWeb.PowRouter do
  use Pow.Phoenix.Routes

  alias BonfireWeb.Router.Helpers, as: Routes

  def after_sign_in_path(%{assigns: %{request_path: path}}) when path != "/",
    do: path

  def after_sign_in_path(conn),
    do: Routes.reading_state_path(conn, :index)
end
