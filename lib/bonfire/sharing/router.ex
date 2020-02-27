defmodule Bonfire.Sharing.Router do
  use Commanded.Commands.Router

  alias Bonfire.Sharing.{
    Commands.StartSharing,
    Aggregate
  }

  identify(Aggregate, by: :user_id, prefix: "sharing-")
  dispatch([StartSharing], to: Aggregate)
end
