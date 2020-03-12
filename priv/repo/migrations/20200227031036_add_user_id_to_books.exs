defmodule Bonfire.Repo.Migrations.AddUserIdToBooks do
  use Ecto.Migration

  def change do
    alter table(:user_books) do
      add :user_id, references(:users)
    end

    drop unique_index(:user_books, [:book_id])
    create unique_index(:user_books, [:user_id, :book_id])
  end
end
