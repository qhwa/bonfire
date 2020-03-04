defmodule Bonfire.Books do
  @moduledoc """
  The Books context.
  """

  import Ecto.Query, warn: false
  alias Bonfire.Repo

  alias Bonfire.Books.{
    Book,
    Metadata,
    GoogleBookAPI,
    DoubanBookApi
  }

  def search_books(keyword) do
    GoogleBookAPI.search_books(keyword)
  end

  def isbn_to_book(%{isbn: isbn, user_id: user_id}) do
    with {:ok, metadata} <- isbn_to_metadata(isbn) do
      metadata_to_book(metadata, user_id)
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
    GoogleBookAPI.find_book_by_isbn(isbn)
    |> case do
      {:ok, %{cover: nil} = book} ->
        {:ok, %{book | cover: DoubanBookApi.get_book_cover(isbn)}}

      book ->
        book
    end
  end

  def create_metadata(book) do
    Metadata.creating_changeset(%Metadata{}, book)
    |> Repo.insert()
  end

  def metadata_to_book(metadata, user_id) do
    case Repo.get_by(Book, metadata_id: metadata.id, user_id: user_id) do
      nil ->
        Book.creating_changeset(%Book{}, %{metadata_id: metadata.id, user_id: user_id})
        |> Repo.insert()

      %Book{} = book ->
        {:ok, book}
    end
  end

  @doc """
  Fix missing cover image.
  """
  def fix_cover(%{cover: nil, isbn: isbn} = metadata) do
    with {:cover, url} when is_binary(url) <- {:cover, DoubanBookApi.get_book_cover(isbn)},
         changeset = Metadata.updating_changeset(metadata, %{cover: url}),
         {:ok, _} <- Repo.update(changeset) do
      :ok
    end
  end
end
