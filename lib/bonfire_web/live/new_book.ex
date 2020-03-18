defmodule BonfireWeb.Live.NewBook do
  @moduledoc false

  require Logger

  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Tracks

  def render(assigns) do
    ~L"""
    <% flash = live_flash(@flash, :info) %>
    <%= if flash do %>
    <div class="notification is-success is-light" phx-click="lv:clear-flash" phx-value-key="info"><%= flash %></div>
    <% end %>

    <%= live_component @socket, BonfireWeb.Live.BookSuggestion, id: :new_book_suggestion %>
    """
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    socket =
      socket
      |> assign(:user_id, user_id)

    {:ok, socket}
  end

  def handle_event("select", %{"isbn" => isbn, "title" => title}, socket) do
    case Tracks.create_reading_state(%{"isbn" => isbn, "user_id" => user_id(socket)}) do
      :ok ->
        {:noreply, socket |> put_flash(:info, "New book (#{title}) added!")}

      {:error, :already_reading} ->
        {:noreply, socket |> put_flash(:info, "You have already added it.")}

      error ->
        Logger.error(["Fail on creating reading track, reason: ", inspect(error)])
        {:noreply, socket}
    end
  end

  defp user_id(socket) do
    socket.assigns.user_id
  end
end
