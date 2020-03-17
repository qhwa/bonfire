defmodule Bonfire.Tracks.Schemas.ReadingState do
  @moduledoc """
  The database schema for reading states.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Bonfire.{
    Users.User,
    Books.UserBook,
    Tracks.Schemas.Checkin
  }

  schema "reading_states" do
    field :finished_at, :utc_datetime
    field :started_at, :utc_datetime
    field :state, :string

    belongs_to :user, User
    belongs_to :user_book, UserBook
    has_many :checkins, Checkin, on_delete: :delete_all

    timestamps()
  end

  def updating_changeset(rs, attrs) do
    cast(rs, attrs, [:state, :started_at, :finished_at])
  end
end
