defmodule Bonfire.Tracks.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    children = [
      Bonfire.Tracks.Projectors.ReadingState
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
