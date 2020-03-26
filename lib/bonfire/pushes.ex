defmodule Bonfire.Pushes do
  @moduledoc """
  High level APIS for push context.
  """

  alias Bonfire.Users.User
  alias Bonfire.Pushes.Schemas.Push
  alias Bonfire.Pushes.Commands.Read

  import Ecto.Query, only: [from: 2]

  @doc """
  Render a push's content into text.
  """
  def render_content([template, payload]),
    do: BonfireWeb.PushContentView.render(template, payload)

  def render_content(text) when is_binary(text),
    do: text

  @doc """
  Get the latest push created for user.
  """
  def latest_push(nil), do: nil
  def latest_push(%User{id: user_id}), do: latest_push(user_id)

  def latest_push(user_id) do
    from(
      p in Push,
      where: p.user_id == ^user_id,
      where: p.state == "created",
      limit: 1,
      order_by: [desc: :inserted_at]
    )
    |> Bonfire.Repo.one()
  end

  @doc """
  Mark a push as read
  """
  def read(push) do
    Bonfire.EventApp.dispatch(%Read{id: push.id, user_id: push.user_id})
  end
end
