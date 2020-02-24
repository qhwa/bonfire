defmodule Bonfire.Books.Metadata do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book_metadatas" do
    field :cover, :string
    field :description, :string
    field :isbn, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def creating_changeset(metadata, attrs) do
    metadata
    |> cast(attrs, [:title, :isbn, :cover, :description])
    |> validate_required([:title, :isbn])
    |> unique_constraint(:isbn)
  end
end
