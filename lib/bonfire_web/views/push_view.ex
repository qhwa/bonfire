defmodule BonfireWeb.PushView do
  use BonfireWeb, :view

  @default_actions %{ok: "Got it!"}

  def render_actions(actions) do
    for action <- actions || @default_actions do
      render_action(action)
    end
  end

  def render_action({event, label}) when is_binary(label) do
    link(label, to: "#", phx_click: to_string(event), class: "card-footer-item #{event}")
  end

  def render_action({event, %{label: label, action: [action, payload]}}) do
    link(label,
      to: "#",
      "phx_value_#{action}": payload,
      phx_click: to_string(event),
      class: "card-footer-item #{event}"
    )
  end
end
