defmodule SvgGenerator.IsometricCube do
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
    |> shear_poly(30, :x)
    |> rotate_poly(-30)
    |> move_to_center()
  end

  def shear_poly(points, degree, axis) do
    Enum.map(points, fn {x, y} ->
      shear_point(x, y, degree, axis)
    end)
  end

  defp shear_point(x, y, degree, :x) do
    # m = hyperbolic cotangent of degree in radians?
    radians = radians(degree)
    m = :math.atanh(radians)
    new_x = x + m * y
    {new_x, y}
  end

  defp shear_point(x, y, degree, :y) do
    radians = radians(degree)
    m = :math.atan(radians)
    new_y = y + m * x
    {x, new_y}
  end

  def move_to_center(points) do
    # Find lowest y (highest y value) and place that point at the center.
    {x, y} = Enum.max_by(points, fn {_x, y} -> y end)
    x_amount = x - @center_x
    y_amount = y - @center_y

    Enum.map(points, fn point ->
      move_point(point, x_amount, :x)
      |> move_point(y_amount, :y)
    end)
  end

  def move_point({x, y}, amount, :x) do
    new_x = x - amount
    {new_x, y}
  end

  def move_point({x, y}, amount, :y) do
    new_y = y - amount
    {x, new_y}
  end

  def rotate_poly(points, degree) do
    Enum.map(points, fn {x, y} ->
      rotate_point(x, y, degree)
    end)
  end

  defp rotate_point(x, y, degree) do
    radians = radians(degree)

    new_x =
      @center_x + (x - @center_x) * :math.cos(radians) - (y - @center_y) * :math.sin(radians)

    new_y =
      @center_y + (y - @center_y) * :math.cos(radians) + (x - @center_x) * :math.sin(radians)

    {new_x, new_y}
  end

  def make_polygon([{x1, y1}, {x2, y2}, {x3, y3}, {x4, y4}]) do
    # make this not dependent on list size
    string_points = "#{x1},#{y1} #{x2},#{y2}, #{x3},#{y3} #{x4},#{y4}"
    polygon(string_points)
  end

  def print() do
    first = first_poly()
    second = rotate_poly(first, 120)
    third = rotate_poly(second, 120)

    isometrics = Enum.map([first, second, third], &make_polygon(&1))

    # debug = rect(@center_x - 1, @center_y - 1, 2, 2)

    isometrics
  end
end
