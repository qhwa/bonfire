defmodule Bonfire.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bonfire.Books.Metadata

  schema "books" do
    belongs_to :metadata, Metadata

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [])
    |> validate_required([])
  end
end
