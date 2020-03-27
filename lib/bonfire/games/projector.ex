defmodule Bonfire.Games.Projector do
  @moduledoc false

  alias Bonfire.Games.Events.GameStarted
  alias Bonfire.Games.Events.StarCollected
  alias Bonfire.Games.Schemas.Game

  import Ecto.Query

  use Commanded.Projections.Ecto,
    application: Bonfire.EventApp,
    repo: Bonfire.Repo,
    name: "game_projection"

  project(%GameStarted{user_id: user_id}, _meta, fn multi ->
    game = %Game{user_id: user_id}
    Ecto.Multi.insert(multi, :new_game, game)
  end)

  project(%StarCollected{user_id: user_id, amount: amount}, _meta, fn multi ->
    user_id != nil or raise "user_id is nil!"

    Ecto.Multi.update_all(
      multi,
      :update_game_star_count,
      from(g in Game,
        where: g.user_id == ^user_id,
        update: [
          set: [
            star_count_in_current_season: fragment("star_count_in_current_season + ?", ^amount),
            star_count_in_total: fragment("star_count_in_total + ?", ^amount)
          ]
        ]
      ),
      []
    )
  end)
end
