defmodule Bonfire.Games do
  @moduledoc """
  Gaming related high level APIs.
  """

  alias Bonfire.EventApp
  alias Bonfire.Games.Commands.StartGame

  def start_game(user) do
    EventApp.dispatch(%StartGame{user_id: user.id})
  end
end
