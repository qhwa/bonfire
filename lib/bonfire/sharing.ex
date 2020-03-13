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
        {:ok, user_id, Bonfire.Tracks.list_reading_states(user_id)}

      nil ->
        {:error, :not_found}
    end
  end

  @doc """
  Get a user's share key.
  """
  def get_share_key(user_id) do
    case Repo.get_by(Profile, user_id: user_id) do
      %{share_key: share_key} ->
        share_key

      nil ->
        nil
    end
  end

  @doc """
  Start sharing with a share key
  """
  def start_sharing(user_id, key) do
    %Bonfire.Sharing.Commands.StartSharing{user_id: user_id, key: key}
    |> Bonfire.EventApp.dispatch(consistency: :strong)
  end
end
