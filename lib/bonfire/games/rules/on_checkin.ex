defmodule Bonfire.Games.Rules.OnCheckin do
  @moduledoc """
  A rule module to watch checkins of users.
  """

  alias Bonfire.Games.Commands.NewStar
  alias Bonfire.Tracks.Events.CheckedIn
  alias Bonfire.Tracks

  @behaviour Bonfire.Games.Rule

  def apply(_, %CheckedIn{track_id: %{user_id: user_id}}) do
    if Tracks.checked_in_today?(user_id) do
      []
    else
      [%NewStar{user_id: user_id}]
    end
  end

  def apply(_, _), do: []
end
