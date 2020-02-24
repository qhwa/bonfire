defmodule Bonfire.Repo.Migrations.CreateBookMetadatas do
  use Ecto.Migration

  def change do
    create table(:book_metadatas) do
      add :title, :string
      add :isbn, :string
      add :cover, :string
      add :description, :text

      timestamps()
    end

    create unique_index(:book_metadatas, [:isbn])
  end
end
