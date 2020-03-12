defmodule Bonfire.Repo.Migrations.AddIsbn10ToMetadatas do
  use Ecto.Migration

  def change do
    alter table(:book_metadatas) do
      add :isbn_10, :string
      add :isbn_13, :string
    end
  end
end
