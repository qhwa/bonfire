defmodule Bonfire.Books.Book do
  @moduledoc """
  A database schema of user_book.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Bonfire.Books.Metadata
  alias Bonfire.Tracks.Schemas.ReadingState
  alias Bonfire.Users.User

  schema "books" do
    belongs_to :metadata, Metadata
    belongs_to :user, User
    has_one :reading_state, ReadingState

    timestamps()
  end

  @doc false
  def creating_changeset(book, attrs) do
    book
    |> cast(attrs, [:metadata_id, :user_id])
    |> validate_required([:metadata_id, :user_id])
  end
end
