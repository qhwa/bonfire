defmodule Bonfire.Games.Rules.FirstCheckin do
  @moduledoc """
  A rule module to watch first checkins of users.
  """

  alias Bonfire.Pushes.Commands.Push
  alias Bonfire.Tracks.Events.CheckedIn

  import Ecto.Query, only: [from: 2]

  @behaviour Bonfire.Games.Rule

  def apply(_, %CheckedIn{track_id: %{user_id: user_id}}) do
    if first_time_checkin?(user_id) do
      [
        %Push{
          user_id: user_id,
          content: ["first_checkin", []],
          allow_dismiss: false
        }
      ]
    else
      []
    end
  end

  def apply(_, _), do: []

  defp first_time_checkin?(user_id) do
    first =
      from(
        c in Bonfire.Tracks.Schemas.Checkin,
        where: c.user_id == ^user_id,
        limit: 1
      )
      |> Bonfire.Repo.one()

    first == nil
  end
end
