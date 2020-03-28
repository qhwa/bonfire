defmodule Bonfire.Sharing.Profile do
  @moduledoc """
  A database schema representing user profiles.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @min_share_key_len 4
  @share_key_format ~r/\A[-a-zA-z]+\Z/

  schema "profiles" do
    field :share_key, :string
    field :timezone, :string

    belongs_to :user, Bonfire.Users.User

    timestamps()
  end

  @doc false
  def creating_changeset(profile, attrs) do
    profile
    |> cast(attrs, [:share_key, :user_id, :timezone])
    |> validate_share_key()
    |> unique_constraint(:share_key)
    |> unique_constraint(:user_id)
  end

  @doc false
  def updating_changeset(profile, attrs) do
    profile
    |> cast(attrs, [:share_key, :timezone])
    |> validate_share_key()
    |> unique_constraint(:share_key)
  end

  defp validate_share_key(changeset) do
    changeset
    |> validate_length(:share_key, min: @min_share_key_len)
    |> validate_format(:share_key, @share_key_format,
      message: "nick name must only contain letters and `-`"
    )
  end
end
