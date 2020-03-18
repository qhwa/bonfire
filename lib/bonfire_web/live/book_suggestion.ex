defmodule BonfireWeb.Live.BookSuggestion do
  @moduledoc false

  require Logger

  use Phoenix.HTML
  use Phoenix.LiveComponent

  alias Bonfire.Books

  def render(assigns) do
    ~L"""
    <section id="book-suggestion">
    <%= form_tag "#", phx_change: :user_input, phx_target: "#book-suggestion", class: "suggestions" do %>
      <div class="field">
        <input type="text" id="q" name="q" class="input" autocomplete="off" phx-debounce="500" placeholder="book title, subtitle, isbn or content keyword" />
      </div>

      <ul>
        <%= for book <- @books, book.isbn do %>
          <%= content_tag :li, class: "book", phx_click: "select", phx_value_isbn: book.isbn, phx_value_title: book.title, phx_value_thumbnail: book.thumbnail do %>

            <div class="cover"><%= img_tag book.thumbnail %></div>

            <div class="info">
              <h4 class="title"><%= book.title %></h4>
              <h5 class="subtitle"><%= book.subtitle %></h5>
              <div class="authors"><%= book.authors %></div>
            </div>

          <% end %>
        <% end %>
      </ul>
    <% end %>
    </section>
    """
  end

  def mount(socket) do
    socket =
      socket
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
end
