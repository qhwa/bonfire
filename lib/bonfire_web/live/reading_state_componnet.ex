defmodule BonfireWeb.Live.ReadingStateComponent do
  @moduledoc false

  use Phoenix.LiveComponent

  alias BonfireWeb.ReadingStateView
  alias Bonfire.Tracks

  def render(assigns) do
    Phoenix.View.render(ReadingStateView, "_state.html", assigns)
  end

  def handle_event("finish", _session, socket) do
    rs = socket.assigns.reading_state
    :ok = Tracks.finish_reading_state(rs.user_book.book.isbn, rs.user_id)
    {:noreply, assign(socket, :reading_state, reload(rs))}
  end

  defp reload(%{id: id}) do
    Tracks.get_reading_state!(id)
  end
end
