defmodule Bonfire.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query
  require Logger

  alias Bonfire.Repo

  alias Bonfire.Books.{
    UserBook,
    Book,
    GoogleBookAPI,
    DoubanBookApi
  }

  def search_books(keyword) do
    GoogleBookAPI.search_books(keyword)
  end

  def isbn_to_user_book(isbn, user_id) do
    with {:ok, book} <- isbn_to_book(isbn) do
      book_to_user_book(book, user_id)
    end
  end

  def isbn_to_book(isbn) do
    case Repo.get_by(Book, isbn: isbn) do
      %Book{} = book ->
        {:ok, book}

      nil ->
        create_book_from_isbn(isbn)
    end
  end

  def create_book_from_isbn(isbn) do
    with {:ok, book_info} <- fetch_book_info(isbn) do
      create_book(book_info)
    end
  end

  def fetch_book_info(isbn) do
    GoogleBookAPI.find_book_by_isbn(isbn)
    |> case do
      {:ok, %{cover: nil} = book} ->
        {:ok, %{book | cover: DoubanBookApi.get_book_cover(isbn)}}

      {:ok, %{cover: url} = book} ->
        {:ok, %{book | cover: cover_on_cdn(url)}}

      other ->
        Logger.error(["Error fetching booking wiht isbn: ", isbn, ", result: ", inspect(other)])
        other
    end
  end

  def create_book(book) do
    Book.creating_changeset(%Book{}, book)
    |> Repo.insert()
  end

  def book_to_user_book(book, user_id) do
    case Repo.get_by(UserBook, book_id: book.id, user_id: user_id) do
      nil ->
        UserBook.creating_changeset(%UserBook{}, %{book_id: book.id, user_id: user_id})
        |> Repo.insert()

      %UserBook{} = user_book ->
        {:ok, user_book}
    end
  end

  @doc """
  Fix missing cover image.
  """
  def fix_cover(%{cover: nil, isbn: isbn} = book) do
    with {:cover, url} when is_binary(url) <- {:cover, DoubanBookApi.get_book_cover(isbn)},
         changeset = Book.updating_changeset(book, %{cover: url}),
         {:ok, _} <- Repo.update(changeset) do
      :ok
    end
  end

  def fix_all_covers! do
    from(data in Book, where: is_nil(data.cover))
    |> Repo.all()
    |> Enum.map(&fix_cover/1)
  end

  @google_book_cover_cdn_host "gbook-cover-proxy.bonfirereading.com"

  defp cover_on_cdn(nil), do: nil

  defp cover_on_cdn(url),
    do: url |> String.replace("books.google.com", @google_book_cover_cdn_host)
end
