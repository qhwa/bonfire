defmodule Bonfire.Pushes.Aggregate do
  @moduledoc false

  defstruct [:user_id]

  alias Bonfire.Pushes.{
    Events.PushCreated,
    Events.PushRead,
    Commands.Push,
    Commands.Read
  }

  def execute(_, %Push{} = cmd) do
    %{cmd | __struct__: PushCreated}
    |> Map.put(:id, UUID.uuid4())
  end

  def execute(_, %Read{user_id: user_id, id: id}) do
    %PushRead{id: id, user_id: user_id}
  end

  def apply(_, %{user_id: user_id}) do
    %__MODULE__{user_id: user_id}
  end
end
