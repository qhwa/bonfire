defmodule BonfireWeb.Live.ReadingState do
  @moduledoc false

  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Tracks

  def render(%{reading_state: :not_found} = assigns) do
    ~L"""
    <div class="container">Not Found</div>
    """
  end

  def render(assigns) do
    Phoenix.View.render(BonfireWeb.ReadingStateView, "show.html", assigns)
  end

  def mount(_params, %{"id" => id, "user_id" => user_id}, socket) do
    with {:ok, rs} <- Tracks.get_reading_state(id, user_id),
         checkins <- Tracks.get_checkins(rs) do
      socket =
        socket
        |> assign(:reading_state, rs)
        |> assign(:user_book, rs.user_book)
        |> assign(:book, rs.user_book.book)
        |> assign(:checkins, checkins)

      {:ok, socket}
    else
      nil ->
        {:ok, assign(socket, :reading_state, :not_found)}
    end
  end
end
