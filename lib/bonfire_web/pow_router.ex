defmodule BonfireWeb.PowRouter do
  @moduledoc false

  use Pow.Phoenix.Routes

  alias BonfireWeb.Router.Helpers, as: Routes

  @landing_pages ~w[/]

  def after_sign_in_path(%{assigns: %{request_path: path}}) when path not in @landing_pages,
    do: path

  def after_sign_in_path(conn),
    do: Routes.reading_state_path(conn, :index)
end
