defmodule Bonfire.Users.User do
  @moduledoc """
  A module representing the User schema in database
  """
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  schema "users" do
    pow_user_fields()

    has_many :reading_states, Bonfire.Tracks.Schemas.ReadingState
    has_many :books, Bonfire.Books.UserBook
    has_many :pushes, Bonfire.Pushes.Schemas.Push

    has_one :profile, Bonfire.Sharing.Profile
    has_one :game, Bonfire.Games.Schemas.Game

    timestamps()
  end
end
