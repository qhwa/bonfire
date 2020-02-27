defmodule Bonfire.Sharing.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "profiles" do
    field :share_key, :string
    belongs_to :user, Bonfire.Users.User

    timestamps()
  end

  @doc false
  def creating_changeset(profile, attrs) do
    profile
    |> cast(attrs, [:share_key, :user_id])
    |> validate_required([:share_key])
    |> unique_constraint(:share_key)
  end
end
