defmodule SvgGenerator.IsometricCube do
  import SvgGenerator.SVG
  import SvgGenerator.Utils

  @moduledoc """
    An isometric projection of a cube is a hexagon.
    Converts a polygon consisting of all right angles into an isometric perspective.
  """
  def first_poly(x, y) do
    # Build a cross shape
    [
      {x, y - 16},
      {x, y - 8},
      {x - 8, y - 8},
      {x - 8, y},
      {x - 16, y},
      {x - 16, y - 8},
      {x - 24, y - 8},
      {x - 24, y - 16},
      {x - 16, y - 16},
      {x - 16, y - 24},
      {x - 8, y - 24},
      {x - 8, y - 16}
    ]
  end

  def isometric(points, x, y) do
    # Vertically scale the shape
    # Shear horizontally 30 degrees
    # Rotate resulting poly -30 degrees
    points
    |> scale_points(0.86062, :y)
    |> shear_points(30, :x)
    |> rotate_points(-30, x, y)
    |> move_to_center(x, y)
  end

  def move_to_center(points, x, y) do
    # Find lowest y (highest y value) and place that point at the center.
    {max_x, max_y} = Enum.max_by(points, fn {_x, y} -> y end)
    x_amount = max_x - x
    y_amount = max_y - y

    move_points(points, x_amount, y_amount)
  end

  def create_trigram(x, y) do
    first = first_poly(x, y) |> isometric(x, y)
    second = rotate_points(first, 120, x, y)
    third = rotate_points(second, 120, x, y)
    Enum.map([first, second, third], &polygon(&1))
  end

  def print_tile?(n, tile_size), do: rem(n, tile_size) == 0

  def print() do
    tile_size = 42
    x_range = 0..width()
    y_range = 0..height()
    # debug = rect(@center_x - 1, @center_y - 1, 2, 2)
    list = []

    for x <- x_range,
        y <- y_range,
        print_tile?(x, tile_size),
        print_tile?(y, tile_size),
        do: create_trigram(x, y) |> Enum.concat(list)
  end
end
