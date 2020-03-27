defmodule Bonfire.Games.Rules.OnStarCollected do
  @moduledoc """
  A rule module to watch star collected events of users.
  """

  alias Bonfire.Pushes.Commands.Push
  alias Bonfire.Games.Events.StarCollected

  @behaviour Bonfire.Games.Rule

  def apply(_, %StarCollected{user_id: user_id, prev_star_count: prev, amount: amount}) do
    [
      %Push{
        user_id: user_id,
        content: ["first_star", %{prev: prev, amount: amount}],
        allow_dismiss: false
      }
    ]
  end

  def apply(_, _), do: []
end
