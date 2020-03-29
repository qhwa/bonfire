defmodule Bonfire.Users.User do
  @moduledoc """
  A module representing the User schema in database
  """
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema

  alias Bonfire.{
    Tracks.Schemas.ReadingState,
    Tracks.Schemas.Checkin,
    Books.UserBook,
    Pushes.Schemas.Push,
    Sharing.Profile,
    Games.Schemas.Game
  }

  schema "users" do
    pow_user_fields()

    has_many :reading_states, ReadingState
    has_many :books, UserBook
    has_many :pushes, Push
    has_many :checkins, Checkin

    has_one :profile, Profile
    has_one :game, Game

    timestamps()
  end
end
