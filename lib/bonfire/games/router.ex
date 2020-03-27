defmodule Bonfire.Games.Router do
  use Commanded.Commands.Router

  alias Bonfire.Games.{
    Commands.StartGame,
    Commands.NewStar,
    Aggregate
  }

  identify(Aggregate, by: :user_id, prefix: "game-")
  dispatch([StartGame, NewStar], to: Aggregate)
end
