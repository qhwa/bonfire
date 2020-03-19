defmodule Bonfire.Sharing.Profile do
  @moduledoc """
  A database schema representing user profiles.
  """

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
    |> unique_constraint(:share_key)
  end

  @doc false
  def updating_changeset(profile, attrs) do
    profile
    |> cast(attrs, [:share_key])
    |> unique_constraint(:share_key)
  end
end
