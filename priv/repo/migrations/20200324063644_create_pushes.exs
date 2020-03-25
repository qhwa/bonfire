defmodule Bonfire.Repo.Migrations.CreatePushes do
  use Ecto.Migration

  def change do
    create table(:pushes, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :content, :text
      add :state, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:pushes, [:user_id, :state])
  end
end
