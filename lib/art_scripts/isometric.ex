defmodule SvgGenerator.IsometricCube do
  import SvgGenerator.SVG
  import SvgGenerator.Utils

  @moduledoc """
    An isometric projection of a cube is a hexagon.
    Draws a hexagon that looks like a cube.
    Eventually to become more interesting.
  """
  @center_x width() / 2
  @center_y height() / 2

  def first_poly() do
    # Build a square
    # Vertically scale the top two points of the square
    scale_amount = 16 * 0.86062
    x1 = @center_x
    y1 = @center_y

    x2 = @center_x - 16
    y2 = @center_y

    x3 = @center_x - 16
    y3 = @center_y - scale_amount

    x4 = @center_x
    y4 = @center_y - scale_amount

    # Shear horizontally 30 degrees
    # Rotate resulting poly -30 degrees
    [{x1, y1}, {x2, y2}, {x3, y3}, {x4, y4}]
    |> shear_points(30, :x)
    |> rotate_points(-30, @center_x, @center_y)
    |> move_to_center()
  end

  def move_to_center(points) do
    # Find lowest y (highest y value) and place that point at the center.
    {x, y} = Enum.max_by(points, fn {_x, y} -> y end)
    x_amount = x - @center_x
    y_amount = y - @center_y

    move_points(points, x_amount, y_amount)
  end

  def print() do
    first = first_poly()
    second = rotate_points(first, 120, @center_x, @center_y)
    third = rotate_points(second, 120, @center_x, @center_y)

    isometrics = Enum.map([first, second, third], &polygon(&1))

    # debug = rect(@center_x - 1, @center_y - 1, 2, 2)

    isometrics
  end
end
