defmodule SvgGenerator.FlowField do
  import SvgGenerator.Utils
  import SvgGenerator.SVG

  @moduledoc """
    many thanks to tyler hobbs for his essay & pseudocode for flow fields
    https://tylerxhobbs.com/essays/2020/flow-fields
  """
  @resolution 5
  @num_steps 360

  @doc """
    Defines a grid of angles
    Grid should be larger than paper size to allow curves to exit and return
    Resolution: Higher is better for smooth curves, lower is better for performance
  """
  def define_grid() do
    # grid_width = (width() * @multiplier) |> round()
    # grid_height = (height() * @multiplier) |> round()

    grid_width = (a5_width() / @resolution) |> round()
    grid_height = (a5_height() / @resolution) |> round()
    x_range = 0..grid_width
    y_range = 0..grid_height
    x_length = x_range |> Enum.count()
    y_length = y_range |> Enum.count()

    Enum.reduce(x_range, %{}, fn x, acc ->
      Enum.reduce(y_range, acc, fn y, acc ->
        point = {x, y}
        x_div = x / x_length
        y_div = y / y_length
        angle = x_div - y_div * :math.pi()

        Map.put(acc, point, angle)
      end)
    end)
  end

  def draw_curves(vertex_grid) do
    grid_height = (a5_height() / @resolution) |> round()
    y_range = 0..grid_height

    Enum.map(y_range, fn y ->
      draw_curve(vertex_grid, y * @resolution)
    end)
  end

  @doc """
    return a path defining a curve through our vertex grid
  """
  def draw_curve(vertex_grid, y) do
    starting_point = {0, y}
    steps = 0..@num_steps

    curve =
      Enum.reduce(steps, [starting_point], fn step, acc ->
        {x, y} = hd(acc)
        x_offset = a5_width() - x
        y_offset = a5_height() - y
        column = (x_offset / @resolution) |> round()
        row = (y_offset / @resolution) |> round()
        lookup = {column, row}
        grid_angle = vertex_grid[lookup]

        if grid_angle do
          [draw_vertex({x, y}, grid_angle, 1) | acc]
        else
          [draw_vertex({x, y}, 90, 1) | acc]
        end
      end)

    path(curve)
  end

  def draw_vertex({x, y}, angle, line_length) do
    end_x = x + :math.cos(angle) * line_length
    end_y = y + :math.sin(angle) * line_length
    {end_x, end_y}
  end

  def print() do
    define_grid()
    |> draw_curves()
  end
end
