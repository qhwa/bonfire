defmodule Bonfire.Games.ProcessManager do
  @moduledoc """
  A proccess manager to proccess game rules.
  """

  use Commanded.ProcessManagers.ProcessManager,
    application: Bonfire.EventApp,
    name: __MODULE__

  alias Bonfire.Games.{
    Rules.Welcome,
    Events.Claimed,
    Events.GameStarted
  }

  @derive Jason.Encoder

  @enforce_keys [:user_id]
  defstruct [:user_id, :rule]

  @rules [Welcome]

  def interested?(%GameStarted{user_id: user_id}), do: {:start, user_id}
  def interested?(_event), do: false

  def handle(_manager, evt) do
    trigger_game_rule(evt)
  end

  defp trigger_game_rule(evt) do
    game_state = nil

    @rules
    |> Enum.reduce([], &[&1.apply(game_state, evt) | &2])
    |> hd()
  end

  def apply(%__MODULE__{} = pm, %GameStarted{}) do
    pm
  end
end
