defmodule Bonfire.Games.Projectors.Game do
  @moduledoc false

  alias Bonfire.Games.Events.GameStarted
  alias Bonfire.Games.Schemas.Game

  use Commanded.Projections.Ecto,
    application: Bonfire.EventApp,
    repo: Bonfire.Repo,
    name: "game_projection"

  project(%GameStarted{user_id: user_id}, _meta, fn multi ->
    game = %Game{user_id: user_id}
    Ecto.Multi.insert(multi, :new_game, game)
  end)
end
