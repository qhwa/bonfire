defmodule Bonfire.Tracks.Schemas.Checkin do
  @moduledoc """
  An Ecto schema representing checkin events.
  """
  use Ecto.Schema

  schema "checkins" do
    field :date, :date
    field :insight, :string

    belongs_to :user, Bonfire.Users.User
    belongs_to :book, Bonfire.Books.Book
    belongs_to :reading_state, Bonfire.Tracks.Schemas.ReadingState

    timestamps()
  end
end
