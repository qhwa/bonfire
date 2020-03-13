defmodule Bonfire.Tracks.Commands.FinishReading do
  @moduledoc """
  A command struct
  """

  @type t :: %{track_id: TrackId.t()}

  defstruct [:track_id]
end
