defmodule Bonfire.Users do
  import Ecto.Query, only: [from: 2]

  alias Bonfire.Sharing.Profile
  alias Bonfire.Repo

  def get_or_create_profile(user_id) do
    from(p in Profile, where: p.user_id == ^user_id)
    |> Repo.one()
    |> case do
      %Profile{} = profile ->
        {:ok, profile}

      nil ->
        Profile.creating_changeset(%Profile{user_id: user_id}, %{})
        |> Repo.insert()
    end
  end
end
