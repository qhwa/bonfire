defmodule BonfireWeb.Live.ReadingStateList do
  @moduledoc false

  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Tracks

  def render(assigns) do
    Phoenix.View.render(BonfireWeb.ReadingStateView, "live_list.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    Phoenix.PubSub.subscribe(Bonfire.PubSub, topic(user_id), link: true)

    socket =
      socket
      |> assign(:reading_states, Tracks.list_reading_states(user_id))
      |> assign(:user_id, user_id)
      |> assign(:stats, Tracks.stats(user_id))

    {:ok, socket}
  end

  defp topic(user_id) do
    "rs:#{user_id}"
  end

  def handle_info({_, :reading_state_updated, _}, socket) do
    user_id = socket.assigns.user_id
    {:noreply, assign(socket, :stats, Tracks.stats(user_id))}
  end
end
