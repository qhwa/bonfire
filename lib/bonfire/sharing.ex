defmodule Bonfire.Sharing do
  @moduledoc """
  Sharing related high level APIs.
  """

  alias Bonfire.Repo
  alias Bonfire.Sharing.Profile

  @doc """
  Get reading states from a share_key
  """
  def get_reading_states_by_profile(share_key) do
    case Repo.get_by(Profile, share_key: share_key) do
      %{user_id: user_id} ->
        {:ok, Bonfire.Tracks.list_reading_states(user_id)}

      nil ->
        {:error, :not_found}
    end
  end
end
