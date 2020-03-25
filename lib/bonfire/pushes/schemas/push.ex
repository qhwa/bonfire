defmodule Bonfire.Pushes.Schemas.Push do
  @moduledoc """
  Ecto schema for pushes.
  """

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "pushes" do
    field :content, :string
    field :state, :string

    belongs_to :user, Bonfire.Users.User

    timestamps()
  end
end
