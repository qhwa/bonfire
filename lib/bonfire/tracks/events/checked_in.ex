defmodule Bonfire.Tracks.Events.CheckedIn do
  @moduledoc """
  Checked in event struct.
  """

  @type t :: %{track_id: TrackId.t(), insight: String.t()}

  @derive Jason.Encoder

  defstruct [:track_id, :insight]
end
