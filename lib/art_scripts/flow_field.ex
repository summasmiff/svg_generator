defmodule SvgGenerator.FlowField do
  import SvgGenerator.Utils
  import SvgGenerator.SVG

  @moduledoc """
    many thanks to tyler hobbs for his essay & pseudocode for flow fields
    https://tylerxhobbs.com/essays/2020/flow-fields
  """
  # controls fineness of grid
  @resolution 5
  @grid_width (a5_width() / @resolution) |> round()
  @grid_height (a5_height() / @resolution) |> round()

  @total_lines 10
  @line_length 3
  # controls length of curves
  @num_steps (a5_width() / @line_length) |> round()

  @doc """
    Defines a grid of angles
    Grid should be larger than paper size to allow curves to exit and return
    Resolution: Higher is better for smooth curves, lower is better for performance
  """
  def define_grid() do
    x_range = 0..@grid_width
    y_range = 0..@grid_height

    Enum.reduce(x_range, %{}, fn x, acc ->
      Enum.reduce(y_range, acc, fn y, acc ->
        x_add = :rand.uniform()
        y_add = :rand.uniform()
        lookup_point = {x + x_add, y + y_add}
        val = noise_2d(lookup_point) + 2
        angle = val * 90
        Map.put(acc, {x, y}, angle)
      end)
    end)
  end

  def draw_curves(vertex_grid) do
    range = 0..@total_lines

    # Enum.map(vertex_grid, fn {key, value} ->
    #   value
    # end)
    # |> Enum.min_max()
    # |> IO.inspect(label: "angle min max")

    Enum.map(range, fn _ ->
      x = Enum.random(0..a5_width())
      y = Enum.random(0..a5_height())
      draw_curve(vertex_grid, {x, y})
    end)
  end

  @doc """
    return a path defining a curve through our vertex grid
  """
  def draw_curve(vertex_grid, starting_point) do
    steps = 0..@num_steps

    curve =
      Enum.reduce(steps, [starting_point], fn _step, acc ->
        {x, y} = hd(acc)
        x_offset = a5_width() - x
        y_offset = a5_height() - y
        lookup_x = (x_offset / @resolution) |> round()
        lookup_y = (y_offset / @resolution) |> round()

        lookup_x = if lookup_x < 0, do: 0, else: lookup_x
        lookup_y = if lookup_y < 0, do: 0, else: lookup_y
        lookup_y = if lookup_y > @grid_height, do: @grid_height, else: lookup_y
        lookup = {lookup_x, lookup_y}
        grid_angle = vertex_grid[lookup]

        if grid_angle do
          [draw_vertex({x, y}, grid_angle, @line_length) | acc]
        else
          IO.inspect(lookup, label: "no grid angle found")
          [draw_vertex({x, y}, 90, @line_length) | acc]
        end
      end)

    path(curve)
  end

  def debug_vertexes(grid) do
    end_x = (a5_width() / @resolution) |> round()
    end_y = (a5_height() / @resolution) |> round()
    x_range = 0..end_x
    y_range = 0..end_y

    Enum.flat_map(x_range, fn x ->
      Enum.map(y_range, fn y ->
        point = {x * @resolution, y * @resolution}
        end_point = draw_vertex(point, grid[{x, y}], 4)

        path([point, end_point])
      end)
    end)
  end

  def draw_vertex({x, y}, angle, line_length) do
    rad = radians(angle)
    end_x = x + :math.cos(rad) * line_length
    end_y = y + :math.sin(rad) * line_length
    {end_x, end_y}
  end

  def print() do
    define_grid()
    |> draw_curves()

    # |> debug_vertexes()
  end
end
