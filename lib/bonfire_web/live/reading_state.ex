defmodule BonfireWeb.Live.ReadingState do
  @moduledoc false

  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Tracks

  def render(assigns) do
    Phoenix.View.render(BonfireWeb.ReadingStateView, "show.html", assigns)
  end

  def mount(_params, %{"id" => id}, socket) do
    rs = Tracks.get_reading_state!(id)

    socket =
      socket
      |> assign(:reading_state, rs)
      |> assign(:book, rs.book)
      |> assign(:info, rs.book.metadata)

    {:ok, socket}
  end
end
