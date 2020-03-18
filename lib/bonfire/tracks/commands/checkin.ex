defmodule Bonfire.Tracks.Commands.Checkin do
  @moduledoc """
  A command struct
  """

  @type t :: %{track_id: TrackId.t(), insight: String.t()}

  defstruct [:track_id, :insight]
end
