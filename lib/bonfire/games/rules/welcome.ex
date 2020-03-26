defmodule Bonfire.Games.Rules.Welcome do
  @moduledoc """
  A rule module to watch new game starting, then deliver a welcome message
  to users.
  """

  alias Bonfire.Pushes.Commands.Push
  alias Bonfire.Games.Events.GameStarted
  alias BonfireWeb.Router.Helpers, as: Routes

  @behaviour Bonfire.Games.Rule

  def apply(_, %GameStarted{user_id: user_id}) do
    [
      %Push{
        user_id: user_id,
        content: ["welcome", []],
        actions: %{
          ok: %{
            label: "Sure, take me there!",
            action: ["redirect", Routes.checkin_path(BonfireWeb.Endpoint, :new)]
          },
          no: "Not now, thanks."
        },
        allow_dismiss: false
      }
    ]
  end

  def apply(_, _), do: []
end
