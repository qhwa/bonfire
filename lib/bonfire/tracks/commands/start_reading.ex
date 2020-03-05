defmodule Bonfire.Tracks.Commands.StartReading do
  @moduledoc """
  A command struct
  """

  @type t :: %{isbn: IsbnId.t()}

  defstruct [:isbn]
end
