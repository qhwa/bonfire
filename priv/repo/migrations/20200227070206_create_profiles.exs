defmodule Bonfire.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :share_key, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:profiles, [:share_key])
    create unique_index(:profiles, [:user_id])
  end
end
