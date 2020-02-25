defmodule Bonfire.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bonfire.Books.Metadata
  alias Bonfire.Tracks.Schemas.ReadingState

  schema "books" do
    belongs_to :metadata, Metadata
    has_one :reading_state, ReadingState

    timestamps()
  end

  @doc false
  def creating_changeset(book, attrs) do
    book
    |> cast(attrs, [:metadata_id])
    |> validate_required([:metadata_id])
    |> unique_constraint(:metadata_id)
  end
end