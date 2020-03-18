defmodule BonfireWeb.CheckinView do
  use BonfireWeb, :view

  def frequency([]), do: nil
  def frequency(checkins) when length(checkins) == 1, do: "once"
  def frequency(checkins) when length(checkins) == 2, do: "a-few"
  def frequency(_), do: "a-lot"

  def week_title(1), do: "this week"
  def week_title(2), do: "last week"
  def week_title(ago), do: "#{ago - 1} weeks ago"
end
