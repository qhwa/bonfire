defmodule Bonfire.Users do
  @moduledoc """
  User context.
  """
  import Ecto.Query, only: [from: 2]

  alias Bonfire.Sharing.Profile
  alias Bonfire.Repo
  alias Bonfire.Users.User

  use PowAssent.Ecto.UserIdentities.Context, repo: Bonfire.Repo, user: User

  @impl true
  def create_user(user_identity_params, user_params, user_id_params) do
    super(user_identity_params, user_params, user_id_params)
    |> case do
      {:ok, user} ->
        Bonfire.Games.start_game(user)
        {:ok, user}

      other ->
        other
    end
  end

  @default_timezone "Etc/UTC"

  @doc """
  Get user's profile.
  """
  def get_profile(user_id) do
    from(p in Profile, where: p.user_id == ^user_id)
    |> Repo.one()
  end

  @doc """
  Get user's profile, create if not exisiting.
  """
  def get_or_create_profile(user_id) do
    get_profile(user_id)
    |> case do
      %Profile{} = profile ->
        {:ok, profile}

      nil ->
        Profile.creating_changeset(%Profile{user_id: user_id}, %{})
        |> Repo.insert()
    end
  end

  @doc """
  Get timezone setting for a user
  """
  def get_timezone(user_id) do
    case get_profile(user_id) do
      nil ->
        @default_timezone

      %{timezone: tz} ->
        tz
    end
  end
end
