defmodule SvgGenerator.FlowField do
  import SvgGenerator.Utils
  import SvgGenerator.SVG

  @moduledoc """
    many thanks to tyler hobbs for his essay & pseudocode for flow fields
    https://tylerxhobbs.com/essays/2020/flow-fields
  """
  @multiplier 1.0
  @resolution 14

  @doc """
    Defines a grid of angles
    Grid should be larger than paper size to allow curves to exit and return
    Resolution: Higher is better for smooth curves, lower is better for performance
  """
  def define_grid() do
    # grid_width = (width() * @multiplier) |> round()
    # grid_height = (height() * @multiplier) |> round()

    grid_width = (width() / @resolution) |> round()
    grid_height = (height() / @resolution) |> round()
    x_range = 0..grid_width
    y_range = 0..grid_height
    x_length = x_range |> Enum.count()
    y_length = y_range |> Enum.count()

    Enum.map(x_range, fn x ->
      Enum.map(y_range, fn y ->
        x_div = x / x_length
        y_div = y / y_length
        angle = x_div - y_div * :math.pi()

        draw_angle({x * @resolution, y * @resolution}, angle, @resolution / 2)
      end)
    end)
  end

  def draw_angle({x, y}, angle, line_length) do
    end_x = x + :math.cos(angle) * line_length
    end_y = y + :math.sin(angle) * line_length
    line = moveTo({x, y}) <> lineTo({end_x, end_y})
    path(line)
  end

  def print() do
    define_grid()
  end
end
