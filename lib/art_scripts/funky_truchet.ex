defmodule SvgGenerator.FunkyTruchet do
  import SvgGenerator.Utils

  @moduledoc """
    Truchet tiles are square tiles decorated with patterns that are not rotationally symmetric.
    When placed in a square tiling of the plane, they can form varied patterns.
  """

  @tiles [:tile1, :tile2, :tile3, :tile4]

  def left_base(x, y) do
    # upper corner small arc
    sweep = 1
    move1 = moveTo(x + 4, y)
    arc1 = arc(4, 4, 0, 0, sweep, x, y + 4)

    # upper corner large arc
    move3 = moveTo(x + 8, y)
    arc3 = arc(8, 8, 0, 0, sweep, x, y + 8)

    # lower corner small arc
    sweep = 0
    move2 = moveTo(x + 16, y + 12)
    arc2 = arc(4, 4, 0, 0, sweep, x + 12, y + 16)

    # lower corner large arc
    move4 = moveTo(x + 16, y + 8)
    arc4 = arc(8, 8, 0, 0, sweep, x + 8, y + 16)

    Enum.join([move1, arc1, move2, arc2, move3, arc3, move4, arc4], " ")
  end

  def right_base(x, y) do
    sweep = 0
    # upper corner small arc
    move1 = moveTo(x + 12, y)
    arc1 = arc(4, 4, 0, 0, sweep, x + 16, y + 4)

    # upper corner large arc
    move3 = moveTo(x + 8, y)
    arc3 = arc(8, 8, 0, 0, sweep, x + 16, y + 8)

    # lower corner small arc
    sweep = 1
    move2 = moveTo(x, y + 12)
    arc2 = arc(4, 4, 0, 0, sweep, x + 4, y + 16)

    # lower corner large arc
    move4 = moveTo(x, y + 8)
    arc4 = arc(8, 8, 0, 0, sweep, x + 8, y + 16)

    Enum.join([move1, arc1, move2, arc2, move3, arc3, move4, arc4], " ")
  end

  def place_tile(:tile1, x, y) do
    # x, y are upper left corner of tile
    # big assymmetrical arc?? crazy
    move5 = moveTo(x + 12, y)
    arc5 = arc(12, 12, 0, 0, 1, x, y + 12)

    # fill in some lines
    move6 = moveTo(x + 5, y + 11)
    line6 = arc(8, 8, 0, 0, 0, x + 4, y + 16)

    move7 = moveTo(x + 11, y + 5)
    line7 = arc(8, 8, 0, 0, 1, x + 16, y + 4)

    Enum.join([left_base(x, y), move5, arc5, move6, line6, move7, line7], " ")
  end

  def place_tile(:tile2, x, y) do
    # big assymmetrical arc?? crazy
    move5 = moveTo(x + 4, y)
    arc5 = arc(12, 12, 0, 0, 0, x + 16, y + 12)

    # fill in some lines
    move6 = moveTo(x, y + 4)
    line6 = arc(8, 8, 0, 0, 1, x + 5, y + 5)

    move7 = moveTo(x + 12, y + 16)
    line7 = arc(8, 8, 0, 0, 0, x + 11, y + 11)

    Enum.join([right_base(x, y), move5, arc5, move6, line6, move7, line7], " ")
  end

  def place_tile(:tile3, x, y) do
    # x, y are upper left corner of tile
    # big assymmetrical arc?? crazy
    move5 = moveTo(x + 4, y + 16)
    arc5 = arc(12, 12, 0, 0, 1, x + 16, y + 4)

    # fill in some lines
    move6 = moveTo(x, y + 12)
    line6 = arc(8, 8, 0, 0, 0, x + 5, y + 11)

    move7 = moveTo(x + 12, y)
    line7 = arc(8, 8, 0, 0, 1, x + 11, y + 5)

    Enum.join([left_base(x, y), move5, arc5, move6, line6, move7, line7], " ")
  end

  def place_tile(:tile4, x, y) do
    # move big assymmetrical arc?? crazy
    move5 = moveTo(x, y + 4)
    arc5 = arc(12, 12, 0, 0, 1, x + 12, y + 16)

    # fill in some lines
    move6 = moveTo(x + 4, y)
    line6 = arc(8, 8, 0, 0, 0, x + 5, y + 5)

    move7 = moveTo(x + 11, y + 11)
    line7 = arc(8, 8, 0, 0, 0, x + 16, y + 12)

    Enum.join([right_base(x, y), move5, arc5, move6, line6, move7, line7], " ")
  end

  def draw_small_rect(x, y, tile_size) do
    rect(x, y, tile_size / 4, tile_size / 4)
  end

  def draw_large_rect(x, y, tile_size) do
    rect(x, y, tile_size, tile_size)
  end

  def print_tile?(n, tile_size), do: rem(n, tile_size) == 0

  def print() do
    x_range = 0..(width() - 16)
    y_range = 0..(height() - 16)
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
