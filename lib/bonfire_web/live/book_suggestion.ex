defmodule BonfireWeb.Live.BookSuggestion do
  use Phoenix.HTML
  use Phoenix.LiveView

  alias Bonfire.Books
  alias Bonfire.Tracks
  alias BonfireWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~L"""
    <%= form_tag "#", [phx_change: :user_input] do %>
      <input type="text" id="q" name="q" autocomplete="off" phx-debounce="500" />
      <ul>
        <%= for book <- @books, book.isbn do %>
        <li>
          <%= link book.title, to: "#", phx_click: "select", phx_value_isbn: book.isbn %>
          <%= book.subtitle %> / <%= book.isbn %>
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

  def handle_event("select", %{"isbn" => isbn}, socket) do
    case Tracks.create_reading_state(%{"isbn" => isbn, "user_id" => user_id(socket)}) do
      :ok ->
        {:noreply,
         socket
         |> put_flash(:info, "reading tracked")
         |> redirect(to: Routes.reading_state_path(BonfireWeb.Endpoint, :index))}

      error ->
        IO.inspect(error, label: :error)
        {:noreply, socket}
    end
  end

  defp user_id(socket) do
    socket.assigns.user_id
  end
end
