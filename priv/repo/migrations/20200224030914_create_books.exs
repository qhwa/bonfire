defmodule Bonfire.Repo.Migrations.CreateBookMetadatas do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :string
      add :subtitle, :string
      add :authors, {:array, :string}
      add :isbn, :string
      add :isbn_10, :string
      add :isbn_13, :string
      add :cover, :string
      add :description, :text
      add :source_platform, :string
      add :source_id, :string

      timestamps()
    end

    create unique_index(:books, [:isbn])
  end
end
