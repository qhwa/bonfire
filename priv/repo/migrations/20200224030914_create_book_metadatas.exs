defmodule Bonfire.Repo.Migrations.CreateBookMetadatas do
  use Ecto.Migration

  def change do
    create table(:book_metadatas) do
      add :title, :string
      add :subtitle, :string
      add :authors, {:array, :string}
      add :isbn, :string
      add :cover, :string
      add :description, :text
      add :source_platform, :string
      add :source_id, :string

      timestamps()
    end

    create unique_index(:book_metadatas, [:isbn])
  end
end
