defmodule BonfireWeb.Live.ReadingStateList do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Tracks

  def render(assigns) do
    Phoenix.View.render(BonfireWeb.ReadingStateView, "list.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    reading_states = Tracks.list_reading_states(user_id)
    {:ok, assign(socket, :reading_states, reading_states)}
  end
end
