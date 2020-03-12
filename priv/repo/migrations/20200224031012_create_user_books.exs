defmodule Bonfire.Repo.Migrations.CreateUserBooks do
  use Ecto.Migration

  def change do
    create table(:user_books) do
      add :book_id, references(:books, on_delete: :nothing)

      timestamps()
    end

    create index(:user_books, [:book_id])
  end
end
