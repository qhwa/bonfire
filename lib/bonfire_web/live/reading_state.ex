defmodule BonfireWeb.Live.ReadingState do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Tracks

  def render(assigns) do
    Phoenix.View.render(BonfireWeb.ReadingStateView, "show.html", assigns)
  end

  def mount(_params, %{"id" => id}, socket) do
    rs = Tracks.get_reading_state!(id)
    {:ok, assign(socket, :reading_state, rs)}
  end
end
