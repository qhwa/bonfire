defmodule Bonfire.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many :reading_states, Bonfire.Tracks.Schemas.ReadingState
    has_many :books, Bonfire.Books.Book
    has_one :profile, Bonfire.Sharing.Profile

    timestamps()
  end
end
