defmodule Bonfire.Sharing do
  alias Bonfire.Repo
  alias Bonfire.Sharing.Profile

  def get_profile(share_key) do
    Repo.get_by(Profile, share_key: share_key)
    |> Repo.preload(user: [reading_states: [book: [:metadata]]])
    |> case do
      %Profile{} = profile ->
        {:ok, profile}

      nil ->
        {:error, :not_found}
    end
  end
end
