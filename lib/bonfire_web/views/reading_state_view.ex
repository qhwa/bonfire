defmodule BonfireWeb.ReadingStateView do
  use BonfireWeb, :view

  def state_label("pending"), do: "planned"
  def state_label("started"), do: "reading"
  def state_label(o), do: o
end
