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

      <%= if @books != [] do %>
      <ul class="dropdown-content">
        <%= for book <- @books, book.isbn do %>
          <%= content_tag :li, class: "book dropdown-item", phx_click: "select", phx_value_isbn: book.isbn, phx_value_title: book.title, phx_value_thumbnail: book.thumbnail do %>

            <%= cover_tag(book.thumbnail) %>

            <div class="info">
              <h4 class="title"><%= book.title %></h4>
              <h5 class="subtitle"><%= book.subtitle %></h5>
              <div class="authors"><%= book.authors %></div>
            </div>

            <div class="buttons">
              <a href="#" class="button">select</a>
            </div>

          <% end %>
        <% end %>
      </ul>
      <% end %>
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

  defp cover_tag(nil) do
    content_tag(:div, "", class: "cover")
  end

  defp cover_tag(thumbnail) do
    content_tag(:div, "", class: "cover", style: "background-image: url(#{thumbnail})")
  end
end
