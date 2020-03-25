defmodule Bonfire.Pushes.Router do
  use Commanded.Commands.Router

  alias Bonfire.Pushes.{
    Commands.Push,
    Aggregate
  }

  identify(Aggregate, by: :user_id, prefix: "push-")
  dispatch([Push], to: Aggregate)
end
