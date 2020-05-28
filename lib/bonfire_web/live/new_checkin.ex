defmodule BonfireWeb.Live.NewCheckin do
  @moduledoc false

  require Logger

  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Tracks
  alias BonfireWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <% flash = live_flash(@flash, :info) %>
    <%= if flash do %>
    <div class="notification is-success is-light" phx-click="lv:clear-flash" phx-value-key="info"><%= flash %></div>
    <% end %>

    <%= if @state == :new do %>
      <%= live_component(@socket, BonfireWeb.Live.BookSuggestion, id: :new_book_suggestion) %>
      <%= if @recent_books != [] do %>
      <section class="recent-books">
        <h6 class="title is-6">recent books</h6>
        <div class="books">
          <ul>
            <%= for book <- @recent_books do %>
              <li phx-click="select" phx-value-isbn="<%= book.isbn %>" phx-value-title="<%= book.title %>" phx-value-thumbnail="<%= book.cover %>">
                <%= BonfireWeb.BookView.cover_tag(book.cover) %>
              </li>
            <% end %>
          </ul>
        </div>
      </section>
      <% end %>
    <% end %>

    <%= if @state == :selected do %>
      <section class="selected">
        <%= BonfireWeb.BookView.cover_tag @book.thumbnail %>
        <h4 class="book-title title"><%= @book.title %></h4>
        <a href="#" class="change button" phx-click="unselect">change</a>
      </section>

      <%= form_tag "#", phx_submit: :submit do %>
        <input type="hidden" name="isbn" value="<%= @book.isbn %>" >

        <div class="field">
          <h4 class="subtitle is-3">Share some insights (optional)</h4>
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
      |> assign(:recent_books, Tracks.recent_checked_books(user_id))

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
        |> redirect(to: Routes.checkin_path(BonfireWeb.Endpoint, :index))
        |> assign(:state, :done)

      {:noreply, socket}
    end
  end

  defp user_id(socket) do
    socket.assigns.user_id
  end
end
