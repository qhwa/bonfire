defmodule Bonfire.Pushes.Aggregate do
  @moduledoc false

  defstruct [:uuid, :state]

  alias Bonfire.Pushes.{
    Events.PushCreated,
    Commands.Push
  }

  def execute(_, %Push{user_id: user_id, content: content}) do
    %PushCreated{uuid: UUID.uuid4(), user_id: user_id, content: content}
  end

  def apply(_, %PushCreated{uuid: uuid}) do
    %__MODULE__{uuid: uuid, state: :created}
  end
end
