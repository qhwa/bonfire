defmodule Bonfire.Tracks.Commands.FinishReading do
  @moduledoc """
  A command struct
  """

  @type t :: %{isbn: IsbnId.t()}

  defstruct [:isbn]
end
