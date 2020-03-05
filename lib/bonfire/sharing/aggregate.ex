defmodule Bonfire.Sharing.Aggregate do
  @moduledoc """
  An aggregate for sharing context.
  """

  defstruct [:user_id, :key]

  alias Bonfire.Sharing.Commands.StartSharing
  alias Bonfire.Sharing.Events.SharingStarted

  @doc false
  def execute(%__MODULE__{user_id: nil}, %StartSharing{user_id: user_id, key: key}) do
    %SharingStarted{user_id: user_id, key: key}
  end

  def execute(%__MODULE__{}, %StartSharing{}) do
    {:error, :already_shared}
  end

  @doc false
  def apply(_, %SharingStarted{user_id: user_id, key: key}) do
    %__MODULE__{user_id: user_id, key: key}
  end
end
