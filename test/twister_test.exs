defmodule TwisterTest do
  use ExUnit.Case
  doctest Twister

  test "greets the world" do
    assert Twister.hello() == :world
  end
end
