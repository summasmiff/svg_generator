defmodule SvgGeneratorTest do
  use ExUnit.Case
  doctest SvgGenerator

  test "greets the world" do
    assert SvgGenerator.hello() == :world
  end
end
