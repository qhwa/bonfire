defmodule Bonfire.Pushes.Router do
  use Commanded.Commands.Router

  alias Bonfire.Pushes.{
    Commands.Push,
    Commands.Read,
    Aggregate
  }

  identify(Aggregate, by: :user_id, prefix: "push-")
  dispatch([Push, Read], to: Aggregate)
end
