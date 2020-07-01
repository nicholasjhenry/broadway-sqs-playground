defmodule BroadwaySqsPlaygroundTest do
  use ExUnit.Case
  doctest BroadwaySqsPlayground

  test "greets the world" do
    assert BroadwaySqsPlayground.hello() == :world
  end
end
