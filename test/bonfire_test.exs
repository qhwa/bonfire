defmodule BonfireTest do
  use ExUnit.Case
  doctest Bonfire

  test "greets the world" do
    assert Bonfire.hello() == :world
  end
end
