defmodule Bonfire.Books.UserBook do
  @moduledoc """
  A database schema of user_book.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Bonfire.Books.Book
  alias Bonfire.Tracks.Schemas.ReadingState
  alias Bonfire.Users.User

  schema "user_books" do
    belongs_to :book, Book
    belongs_to :user, User
    has_one :reading_state, ReadingState

    timestamps()
  end

  @doc false
  def creating_changeset(book, attrs) do
    book
    |> cast(attrs, [:book_id, :user_id])
    |> validate_required([:book_id, :user_id])
  end
end
