defmodule BonfireWeb.GameView do
  use BonfireWeb, :view

  def render_index(1), do: "🥇"
  def render_index(2), do: "🥈"
  def render_index(3), do: "🥉"
  def render_index(n), do: to_string(n)

  def render_user(%{user: %{profile: %{share_key: name}}}) when is_binary(name) do
    link(name, to: Routes.profile_path(BonfireWeb.Endpoint, :show, name))
  end

  def render_user(%{user: %{email: email}}) when is_binary(email) do
    email
    |> String.replace(~r/@.+\./, "@***.")
  end
end
