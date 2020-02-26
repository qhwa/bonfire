defmodule BonfireWeb.Live.ReadingStateList do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Tracks

  def render(assigns) do
    Phoenix.View.render(BonfireWeb.ReadingStateView, "list.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :reading_states, Tracks.list_reading_states())}
  end

  def handle_event("finish", %{"isbn" => isbn}, socket) do
    Tracks.finish_reading_state(isbn)

    {:noreply, assign(socket, :reading_states, Tracks.list_reading_states())}
  end
end
