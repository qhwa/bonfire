defmodule Bonfire.Tracks.Schemas.ReadingState do
  @moduledoc """
  The database schema for reading states.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "reading_states" do
    field :finished_at, :utc_datetime
    field :started_at, :utc_datetime
    field :state, :string

    belongs_to :user, Bonfire.Users.User
    belongs_to :user_book, Bonfire.Books.UserBook

    timestamps()
  end

  def updating_changeset(rs, attrs) do
    cast(rs, attrs, [:state, :started_at, :finished_at])
  end
end
