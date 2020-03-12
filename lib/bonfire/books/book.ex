defmodule Bonfire.Books.Book do
  @moduledoc """
  Database schema of book metadatas.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :cover, :string
    field :description, :string
    field :isbn, :string
    field :isbn_10, :string
    field :isbn_13, :string
    field :title, :string
    field :subtitle, :string
    field :source_platform, :string
    field :source_id, :string
    field :authors, {:array, :string}

    has_many :user_books, Bonfire.Books.UserBook

    timestamps()
  end

  @doc false
  def creating_changeset(book, attrs) do
    book
    |> cast(attrs, [
      :title,
      :subtitle,
      :authors,
      :isbn,
      :isbn_10,
      :isbn_13,
      :cover,
      :description,
      :source_platform,
      :source_id
    ])
    |> validate_required([:title, :isbn])
    |> unique_constraint(:isbn)
  end

  def updating_changeset(book, attrs) do
    book
    |> cast(attrs, [
      :subtitle,
      :authors,
      :cover,
      :description
    ])
  end
end
