defmodule Bonfire.Tracks.Events.ReadingUntracked do
  @moduledoc """
  A struct representing reading state untracked event.
  """

  @derive Jason.Encoder

  @type t :: %{track_id: TrackId.t()}

  defstruct [:track_id]
end
