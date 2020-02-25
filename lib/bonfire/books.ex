defmodule Bonfire.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Bonfire.Repo

  alias Bonfire.Books.{Book, Metadata}
  alias Bonfire.Books.GoogleBookAPI, as: API

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books,
    do: Repo.all(Book) |> Repo.preload([:metadata])

  @doc """
  Gets a single book.

  Raises if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

  """
  def get_book!(id),
    do: Repo.get!(Book, id) |> Repo.preload([:metadata])

  @doc """
  Creates a book.

  ## Examples

      iex> create_book(%{field: value})
      {:ok, %Book{}}

      iex> create_book(%{field: bad_value})
      {:error, ...}

  """
  def create_book(attrs \\ %{}) do
    raise "TODO"
  end

  @doc """
  Updates a book.

  ## Examples

      iex> update_book(book, %{field: new_value})
      {:ok, %Book{}}

      iex> update_book(book, %{field: bad_value})
      {:error, ...}

  """
  def update_book(%Book{} = book, attrs) do
    raise "TODO"
  end

  @doc """
  Deletes a Book.

  ## Examples

      iex> delete_book(book)
      {:ok, %Book{}}

      iex> delete_book(book)
      {:error, ...}

  """
  def delete_book(%Book{} = book) do
    raise "TODO"
  end

  @doc """
  Returns a data structure for tracking book changes.

  ## Examples

      iex> change_book(book)
      %Todo{...}

  """
  def change_book(%Book{} = book) do
    raise "TODO"
  end

  def isbn_to_book_id(isbn) do
    with {:ok, metadata} <- isbn_to_metadata(isbn) do
      metadata_to_book(metadata)
    end
  end

  def isbn_to_metadata(isbn) do
    case Repo.get_by(Metadata, isbn: isbn) do
      %Metadata{} = metadata ->
        {:ok, metadata}

      nil ->
        create_metadata_from_isbn(isbn)
    end
  end

  def create_metadata_from_isbn(isbn) do
    with {:ok, book_info} <- fetch_book_info(isbn) do
      create_metadata(book_info)
    end
  end

  def fetch_book_info(isbn) do
    API.find_book(isbn: isbn)
  end

  def create_metadata(book) do
    Metadata.creating_changeset(%Metadata{}, book)
    |> Repo.insert()
  end

  def metadata_to_book(metadata) do
    case Repo.get_by(Book, metadata_id: metadata.id) do
      nil ->
        Book.creating_changeset(%Book{}, %{metadata_id: metadata.id})
        |> Repo.insert()

      %Book{} = book ->
        {:ok, book}
    end
  end
end
