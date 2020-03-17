defmodule Bonfire.Tracks.Schemas.Checkin do
  use Ecto.Schema

  schema "checkins" do
    field :date, :date
    field :insight, :string

    belongs_to :user, Bonfire.Users.User
    belongs_to :reading_state, Bonfire.Tracks.Schemas.ReadingState

    timestamps()
  end
end
