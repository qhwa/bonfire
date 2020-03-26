defmodule Bonfire.Games.ProcessManager do
  @moduledoc """
  A proccess manager to proccess game rules.
  """

  use Commanded.ProcessManagers.ProcessManager,
    application: Bonfire.EventApp,
    name: __MODULE__

  alias Bonfire.Games.Events.GameStarted
  alias Bonfire.Tracks.Events.CheckedIn

  @derive Jason.Encoder

  @enforce_keys [:user_id]
  defstruct [:user_id, :rule]

  @rules [
    Bonfire.Games.Rules.Welcome,
    Bonfire.Games.Rules.FirstCheckin
  ]

  def interested?(%GameStarted{user_id: user_id}), do: {:start, user_id}
  def interested?(%CheckedIn{track_id: %{user_id: user_id}}), do: {:continue, user_id}
  def interested?(_event), do: false

  def handle(_manager, evt) do
    trigger_game_rule(evt)
  end

  defp trigger_game_rule(evt) do
    game_state = nil

    @rules |> Enum.flat_map(& &1.apply(game_state, evt))
  end

  def apply(pm, _), do: pm
end
