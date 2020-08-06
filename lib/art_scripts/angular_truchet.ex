defmodule SvgGenerator.AngularTruchet do
  import SvgGenerator.Utils

  @moduledoc """
    Truchet tiles are square tiles decorated with patterns that are not rotationally symmetric.
    When placed in a square tiling of the plane, they can form varied patterns.
  """

  @tiles [:tile1, :tile2, :tile3]

  def place_tile(:tile1, x, y) do
    # x, y are upper left corner of tile
    a1 = moveTo(x, y + 4)
    a2 = lineTo(x + 4, y)
    b1 = moveTo(x, y + 8)
    b2 = lineTo(x + 8, y)
    c1 = moveTo(x, y + 12)
    c2 = lineTo(x + 12, y)

    d1 = moveTo(x + 4, y + 16)
    d2 = lineTo(x + 16, y + 4)
    e1 = moveTo(x + 8, y + 16)
    e2 = lineTo(x + 16, y + 8)
    f1 = moveTo(x + 12, y + 16)
    f2 = lineTo(x + 16, y + 12)
    Enum.join([a1, a2, b1, b2, c1, c2, d1, d2, e1, e2, f1, f2], " ")
  end

  def place_tile(:tile2, x, y) do
    # x, y are upper left corner of tile
    a1 = moveTo(x + 12, y)
    a2 = lineTo(x + 16, y + 4)
    b1 = moveTo(x + 8, y)
    b2 = lineTo(x + 16, y + 8)
    c1 = moveTo(x + 4, y)
    c2 = lineTo(x + 16, y + 12)
    d1 = moveTo(x, y + 4)
    d2 = lineTo(x + 12, y + 16)
    e1 = moveTo(x, y + 8)
    e2 = lineTo(x + 8, y + 16)
    f1 = moveTo(x, y + 12)
    f2 = lineTo(x + 4, y + 16)
    Enum.join([a1, a2, b1, b2, c1, c2, d1, d2, e1, e2, f1, f2], " ")
  end

  def place_tile(:tile3, x, y) do
    a1 = moveTo(x + 4, y)
    a2 = lineTo(x + 4, y + 16)
    b1 = moveTo(x + 8, y)
    b2 = lineTo(x + 8, y + 16)
    c1 = moveTo(x + 12, y)
    c2 = lineTo(x + 12, y + 16)
    d1 = moveTo(x, y + 4)
    d2 = lineTo(x + 4, y + 4)
    e1 = moveTo(x, y + 8)
    e2 = lineTo(x + 4, y + 8)
    f1 = moveTo(x, y + 12)
    f2 = lineTo(x + 4, y + 12)
    g1 = moveTo(x + 12, y + 4)
    g2 = lineTo(x + 16, y + 4)
    h1 = moveTo(x + 12, y + 8)
    h2 = lineTo(x + 16, y + 8)
    i1 = moveTo(x + 12, y + 12)
    i2 = lineTo(x + 16, y + 12)
    Enum.join([a1, a2, b1, b2, c1, c2, d1, d2, e1, e2, f1, f2, g1, g2, h1, h2, i1, i2], " ")
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

    angles =
      for x <- x_range,
          y <- y_range,
          print_tile?(x, tile_size),
          print_tile?(y, tile_size),
          do: Enum.random(@tiles) |> place_tile(x, y)

    [path(angles)]
  end
end
