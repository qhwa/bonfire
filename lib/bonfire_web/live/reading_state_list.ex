defmodule BonfireWeb.Live.ReadingStateList do
  @moduledoc false

  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Tracks

  def render(assigns) do
    Phoenix.View.render(BonfireWeb.ReadingStateView, "live_list.html", assigns)
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    socket =
      socket
      |> assign(:reading_states, Tracks.list_reading_states(user_id))
      |> assign(:stats, %{total: 0, reading: 0, finished: 0})

    {:ok, socket}
  end
end
