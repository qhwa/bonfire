defmodule Bonfire.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :metadata, :id

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [])
    |> validate_required([])
  end
end
