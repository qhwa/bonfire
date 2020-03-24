defmodule Bonfire.Games.Router do
  use Commanded.Commands.Router

  alias Bonfire.Games.{
    Commands.StartGame,
    Aggregate
  }

  identify(Aggregate, by: :user_id, prefix: "game-")
  dispatch([StartGame], to: Aggregate)
end
