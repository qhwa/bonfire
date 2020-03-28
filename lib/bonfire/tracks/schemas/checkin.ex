defmodule Bonfire.Tracks.Schemas.Checkin do
  @moduledoc """
  An Ecto schema representing checkin events.
  """
  use Ecto.Schema

  import Ecto.Query, only: [from: 2]

  schema "checkins" do
    field :date, :date
    field :insight, :string

    belongs_to :user, Bonfire.Users.User
    belongs_to :book, Bonfire.Books.Book
    belongs_to :reading_state, Bonfire.Tracks.Schemas.ReadingState

    timestamps()
  end

  def recent do
    from(c in __MODULE__,
      order_by: [desc: :inserted_at],
      where: c.inserted_at > from_now(-7, "day")
    )
  end
end
