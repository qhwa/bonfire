defmodule Bonfire.Pushes.Aggregate do
  @moduledoc false

  defstruct [:user_id]

  alias Bonfire.Pushes.{
    Events.PushCreated,
    Events.PushRead,
    Commands.Push,
    Commands.Read
  }

  def execute(_, %Push{user_id: user_id, content: content}) do
    %PushCreated{id: UUID.uuid4(), user_id: user_id, content: content}
  end

  def execute(_, %Read{user_id: user_id, id: id}) do
    %PushRead{id: id, user_id: user_id}
  end

  def apply(_, %{user_id: user_id}) do
    %__MODULE__{user_id: user_id}
  end
end
