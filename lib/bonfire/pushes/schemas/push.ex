defmodule Bonfire.Pushes.Schemas.Push do
  @moduledoc """
  Ecto schema for pushes.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "pushes" do
    field :content, :string
    field :state, :string
    field :actions, Util.Term
    field :allow_dismiss, :boolean

    belongs_to :user, Bonfire.Users.User

    timestamps()
  end

  def from_event(evt) do
    struct(__MODULE__, Map.from_struct(evt))
    |> Map.put(:state, "created")
  end

  def read_changeset(push) do
    push
    |> cast(%{}, [])
    |> put_change(:state, "read")
  end
end
