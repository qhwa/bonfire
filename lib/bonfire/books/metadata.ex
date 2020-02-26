defmodule Bonfire.Books.Metadata do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book_metadatas" do
    field :cover, :string
    field :description, :string
    field :isbn, :string
    field :title, :string
    field :subtitle, :string
    field :source_platform, :string
    field :source_id, :string
    field :authors, {:array, :string}

    timestamps()
  end

  @doc false
  def creating_changeset(metadata, attrs) do
    metadata
    |> cast(attrs, [
      :title,
      :subtitle,
      :authors,
      :isbn,
      :cover,
      :description,
      :source_platform,
      :source_id
    ])
    |> validate_required([:title, :isbn])
    |> unique_constraint(:isbn)
  end
end
