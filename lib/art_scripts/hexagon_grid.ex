defmodule SvgGenerator.HexagonGrid do
  import SvgGenerator.SVG
  import SvgGenerator.Utils

  @moduledoc """
    Generates a hexagon tiling
    Bee shape, strong, efficient
    Leans heavily on https://www.redblobgames.com/grids/hexagons/
  """
  @doc """
  returns a list of points defining a regular hexagon (oriented with a pointy top)
  """
  defguard is_even(value) when is_integer(value) and rem(value, 2) == 0

  def hexagon(center, radius) do
    n_sided(6, center, radius)
    |> polygon()
  end

  def offset(y, hex_width) when is_even(y) do
    hex_width / 2
  end

  def offset(_y, _hex_width), do: 0

  def print() do
    radius = 10
    hex_width = :math.sqrt(3) * radius
    hex_across = (a5_width() / hex_width) |> round()

    x_range = 0..hex_across
    hex_height = radius * 1.5
    max_y = (a5_height() / hex_height) |> round()
    y_range = 0..max_y
    # debug = rect(@center_x - 1, @center_y - 1, 2, 2)

    for x <- x_range,
        y <- y_range do
      x_position = x * hex_width
      x_with_offset = x_position + offset(y, hex_width)
      y_position = hex_height * y
      hexagon({x_with_offset, y_position}, radius)
    end
  end
end
