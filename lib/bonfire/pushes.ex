defmodule Bonfire.Pushes do
  @moduledoc """
  High level APIS for push context.
  """

  def render_content([template, payload]) do
    BonfireWeb.PushView.render(BonfireWeb.Endpoint, template, payload)
  end

  def render_content(text) when is_binary(text) do
    text
  end
end
