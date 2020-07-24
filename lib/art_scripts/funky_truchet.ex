defmodule SvgGenerator.FunkyTruchet do
  import SvgGenerator.Utils

  @moduledoc """
    Truchet tiles are square tiles decorated with patterns that are not rotationally symmetric.
    When placed in a square tiling of the plane, they can form varied patterns.
  """

  @tile1 {0, 8, 0, :arc}
  @tile2 {8, 0, 1, :arc}
  @tile3 {4, 4, 0, :x_line}
  @tile4 {4, 4, 0, :y_line}
  @tiles [@tile1, @tile2]

  def place_tile({x1_mod, x2_mod, sweep_flag, :arc}, x, y) do
    # x, y are upper left corner of tile
    # moveTo upper center
    move1 = moveTo(x + 4, y)
    # arc to one side
    arc1 = arc(4, 4, 0, 0, sweep_flag, x + x1_mod, y - 4)
    # moveTo lower center
    move2 = moveTo(x + 4, y - 8)
    # arc to other side
    arc2 = arc(4, 4, 0, 0, sweep_flag, x + x2_mod, y - 4)
    move1 <> " " <> arc1 <> " " <> move2 <> " " <> arc2
  end

  def place_tile({_rx, _ry, _sweep_flag, :x_line}, x, y) do
    tile = moveTo(x, y - 4)
    tile <> " " <> lineTo(x + 8, y - 4) <> " "
  end

  def place_tile({_rx, _ry, :y_line}, x, y) do
    tile = moveTo(x + 4, y)
    tile <> " " <> lineTo(x + 4, y - 8) <> " "
  end

  def draw_rect(x, y) do
    rect(x, y, 8, 8)
  end

  def multiple_of_8?(n), do: rem(n, 8) == 0

  def print() do
    x_range = 0..width()
    y_range = 0..height()

    # grid =
    #   for x <- x_range,
    #       y <- y_range,
    #       multiple_of_8?(x),
    #       multiple_of_8?(y),
    #       do: draw_rect(x, y),
    #       into: []

    curves =
      for x <- x_range,
          y <- y_range,
          multiple_of_8?(x),
          multiple_of_8?(y),
          do: Enum.random(@tiles) |> place_tile(x, y)

    [path(curves)]
  end
end
