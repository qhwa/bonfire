defmodule BonfireWeb.Live.ReadingStateComponent do
  use Phoenix.LiveComponent

  alias BonfireWeb.ReadingStateView
  alias Bonfire.Tracks

  def render(assigns) do
    Phoenix.View.render(ReadingStateView, "_state.html", assigns)
  end

  def handle_event("finish", _session, socket) do
    rs = socket.assigns.reading_state
    :ok = Tracks.finish_reading_state(rs.book.metadata.isbn, rs.book.user_id)
    {:noreply, assign(socket, :reading_state, reload(rs))}
  end

  defp reload(%{id: id}) do
    Tracks.get_reading_state!(id)
  end
end
