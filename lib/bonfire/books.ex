defmodule Bonfire.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Bonfire.Repo

  alias Bonfire.Books.{Book, Metadata}

  @doc """
  Returns the list of books.

  ## Examples

      iex> list_books()
      [%Book{}, ...]

  """
  def list_books do
    Repo.all(Book)
    |> Repo.preload([:metadata])
  end

  @doc """
  Gets a single book.

  Raises if the Book does not exist.

  ## Examples

      iex> get_book!(123)
      %Book{}

  """
  def get_book!(id), do: Repo.get!(Book, id)

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
end
