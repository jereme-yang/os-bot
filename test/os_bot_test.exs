defmodule OsBotTest do
  use ExUnit.Case
  doctest OsBot

  test "greets the world" do
    assert OsBot.hello() == :world
  end
end
