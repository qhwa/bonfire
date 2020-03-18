defmodule BonfireWeb.Live.NewCheckin do
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

    <%= if @state == :new, do: live_component(@socket, BonfireWeb.Live.BookSuggestion, id: :new_book_suggestion) %>

    <%= if @state == :selected do %>
      <%= if @book.thumbnail, do: img_tag @book.thumbnail %>
      <%= @book.title %>
      <a href="#" phx-click="unselect">change</a>

      <%= form_tag "#", phx_submit: :submit do %>
        <input type="hidden" name="isbn" value="<%= @book.isbn %>" >

        <div class="field">
          <label class="label">Any insight?</label>
          <textarea class="textarea" name="insight" placeholder="anything you want to share"></textarea>
        </div>

        <div class="field">
          <input type="submit" class="button is-primary" value="check in">
        </div>
      <% end %>
    <% end %>
    """
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    socket =
      socket
      |> assign(:user_id, user_id)
      |> assign(:state, :new)

    {:ok, socket}
  end

  def handle_event("select", book, socket) do
    book = %{isbn: book["isbn"], title: book["title"], thumbnail: book["thumbnail"]}

    socket =
      socket
      |> assign(:book, book)
      |> assign(:state, :selected)

    {:noreply, socket}
  end

  def handle_event("unselect", _, socket) do
    socket =
      socket
      |> assign(:book, nil)
      |> assign(:state, :new)

    {:noreply, socket}
  end

  def handle_event("submit", %{"isbn" => isbn, "insight" => insight}, socket) do
    with :ok <- Tracks.checkin(isbn, user_id(socket), insight) do
      socket =
        socket
        |> put_flash(:info, "Well done!")
        |> assign(:state, :done)

      {:noreply, socket}
    end
  end

  defp user_id(socket) do
    socket.assigns.user_id
  end
end
