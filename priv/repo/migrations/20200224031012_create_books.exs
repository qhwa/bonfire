defmodule Bonfire.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :metadata, references(:book_metadatas, on_delete: :nothing)

      timestamps()
    end

    create index(:books, [:metadata])
  end
end
