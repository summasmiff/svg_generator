defmodule SvgGenerator.FunkyTruchet do
  import SvgGenerator.Utils

  @moduledoc """
    Truchet tiles are square tiles decorated with patterns that are not rotationally symmetric.
    When placed in a square tiling of the plane, they can form varied patterns.
  """

  @tiles [:tile1, :tile2]

  def place_tile(:tile1, x, y) do
    # x, y are upper left corner of tile
    # upper corner small arc
    sweep = 1
    move1 = moveTo(x + 4, y)
    arc1 = arc(4, 4, 0, 0, sweep, x, y + 4)

    # upper corner large arc
    move3 = moveTo(x + 8, y)
    arc3 = arc(8, 8, 0, 0, sweep, x, y + 8)

    # big assymmetrical arc?? crazy
    move5 = moveTo(x + 12, y)
    arc5 = arc(12, 12, 0, 0, sweep, x, y + 12)

    # lower corner small arc
    sweep = 0
    move2 = moveTo(x + 16, y + 12)
    arc2 = arc(4, 4, 0, 0, sweep, x + 12, y + 16)

    # lower corner large arc
    move4 = moveTo(x + 16, y + 8)
    arc4 = arc(8, 8, 0, 0, sweep, x + 8, y + 16)

    # fill in some lines
    move6 = moveTo(x + 4, y + 12)
    line6 = lineTo(x + 4, y + 16)

    move7 = moveTo(x + 12, y + 4)
    line7 = lineTo(x + 16, y + 4)

    Enum.join(
      [
        move1,
        arc1,
        move2,
        arc2,
        move3,
        arc3,
        move4,
        arc4,
        move5,
        arc5,
        move6,
        line6,
        move7,
        line7
      ],
      " "
    )
  end

  def place_tile(:tile2, x, y) do
    # upper corner small arc
    sweep = 0
    move1 = moveTo(x + 12, y)
    arc1 = arc(4, 4, 0, 0, sweep, x + 16, y + 4)

    # upper corner large arc
    move3 = moveTo(x + 8, y)
    arc3 = arc(8, 8, 0, 0, sweep, x + 16, y + 8)

    # big assymmetrical arc?? crazy
    move5 = moveTo(x + 4, y)
    arc5 = arc(12, 12, 0, 0, sweep, x + 16, y + 12)

    # lower corner small arc
    sweep = 1
    move2 = moveTo(x, y + 12)
    arc2 = arc(4, 4, 0, 0, sweep, x + 4, y + 16)

    # lower corner large arc
    move4 = moveTo(x, y + 8)
    arc4 = arc(8, 8, 0, 0, sweep, x + 8, y + 16)

    # fill in some lines
    move6 = moveTo(x, y + 4)
    line6 = lineTo(x + 4, y + 4)

    move7 = moveTo(x + 12, y + 16)
    line7 = lineTo(x + 12, y + 12)

    Enum.join(
      [
        move1,
        arc1,
        move2,
        arc2,
        move3,
        arc3,
        move4,
        arc4,
        move5,
        arc5,
        move6,
        line6,
        move7,
        line7
      ],
      " "
    )
  end

  def draw_small_rect(x, y, tile_size) do
    rect(x, y, tile_size / 4, tile_size / 4)
  end

  def draw_large_rect(x, y, tile_size) do
    rect(x, y, tile_size, tile_size)
  end

  def print_tile?(n, tile_size), do: rem(n, tile_size) == 0

  def print() do
    x_range = 0..width()
    y_range = 0..height()
    tile_size = 16

    # debug_grid =
    #   for x <- x_range,
    #       y <- y_range,
    #       print_tile?(x, tile_size),
    #       print_tile?(y, tile_size),
    #       do: draw_small_rect(x, y, tile_size),
    #       into: []

    # debug_large_grid =
    #   for x <- x_range,
    #       y <- y_range,
    #       print_tile?(x, tile_size),
    #       print_tile?(y, tile_size),
    #       do: draw_large_rect(x, y, tile_size),
    #       into: []

    curves =
      for x <- x_range,
          y <- y_range,
          print_tile?(x, tile_size),
          print_tile?(y, tile_size),
          do: Enum.random(@tiles) |> place_tile(x, y)

    [path(curves)]
  end
end
