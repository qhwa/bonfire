defmodule Skylab.DockerizeTest do
  use ExUnit.Case
  doctest Skylab.Dockerize

  test "greets the world" do
    assert Skylab.Dockerize.hello() == :world
  end
end
