defmodule BonfireWeb.BookController do
  use BonfireWeb, :controller

  alias Bonfire.Books

  def show(conn, %{"id" => id}) do
    book = Books.get_book!(id)

    render(
      conn,
      "show.html",
      book: book,
      info: book.metadata,
      reading_state: book.reading_state
    )
  end
end
