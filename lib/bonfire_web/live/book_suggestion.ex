defmodule BonfireWeb.Live.BookSuggestion do
  @moduledoc false

  require Logger

  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Books
  alias Bonfire.Tracks

  def render(assigns) do
    ~L"""
    <% flash = live_flash(@flash, :info) %>
    <%= if flash do %>
    <div class="notification is-success is-light" phx-click="lv:clear-flash" phx-value-key="info"><%= flash %></div>
    <% end %>

    <%= form_tag "#", phx_change: :user_input, class: "suggestions" do %>
      <div class="field">
        <label class="label">search</label>
        <input type="text" id="q" name="q" class="input" autocomplete="off" phx-debounce="500" placeholder="book title, subtitle, isbn or content keyword" />
      </div>

      <ul>
        <%= for book <- @books, book.isbn do %>
        <li class="book">
          <div class="cover">
          <%= link to: "#", phx_click: "select", phx_value_isbn: book.isbn, phx_value_isbn: book.title do %>
          <img src="<%= book.thumbnail %>" />
          <% end %>
          </div>

          <div class="info">
            <h4 class="title"><%= link book.title, to: "#", phx_click: "select", phx_value_isbn: book.isbn, phx_value_title: book.title, class: "title" %></h4>
            <h5 class="subtitle"><%= book.subtitle %></h5>
            <div class="authors"><%= book.authors %></div>
          </div>
        </li>
        <% end %>
      </ul>
    <% end %>
    """
  end

  def mount(_params, %{"user_id" => user_id}, socket) do
    socket =
      socket
      |> assign(:user_id, user_id)
      |> assign(:books, [])

    {:ok, socket}
  end

  def handle_event("user_input", %{"q" => ""}, socket) do
    {:noreply, assign(socket, :books, [])}
  end

  def handle_event("user_input", %{"q" => input}, socket) do
    books = Books.search_books(input)
    {:noreply, assign(socket, :books, books)}
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
