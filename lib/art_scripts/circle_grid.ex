defmodule SvgGenerator.CircleGrid do
  require Logger
  require Integer
  import SvgGenerator.SVG

  @moduledoc """
    Inspired by Bridget Riley pieces "Hesitate", "Metamorphosis"
    https://www.instructables.com/id/Bridget-Riley-style-op-art/
    @magic and @zazz are semi-random ints that control the spacing and size of circles
    try:
    @magic: 1-5
    @zazz: 10-20
  """
  @magic 2
  @zazz 17

  @doc """
    to call: print_circles_grid([], a, b)
    where "a" controls ellipses' x and rx
    and "b" controls ellipses' y and ry
  """
  def print_circles_grid(circle_list, a, b), do: print_circles_grid(circle_list, a, b, a, b)

  def print_circles_grid(circle_list, 0, 0, _a1, _b2) do
    circle_list
  end

  def print_circles_grid(circle_list, a, 0, a1, b2) do
    percent = a / a1
    x = a * percent * @zazz

    ry = b2 / @magic

    rx =
      case a / @magic > ry do
        true -> ry
        false -> a / @magic
      end

    circle_list =
      case Integer.is_odd(a) do
        false -> circle_list
        _ -> [ellipse(x, 0, rx, ry) | circle_list]
      end

    print_circles_grid(circle_list, a - 1, b2, a1, b2)
  end

  def print_circles_grid(circle_list, 0, b, a1, b2) do
    ry = b2 / @magic

    circle_list =
      case Integer.is_odd(b) do
        false -> circle_list
        _ -> [ellipse(0, b * @zazz, 1, ry) | circle_list]
      end

    print_circles_grid(circle_list, 0, b - 1, a1, b2)
  end

  def print_circles_grid(circle_list, a, b, a1, b2) do
    percent = a / a1
    x = a * percent * @zazz
    ry = b2 / @magic

    rx =
      case a / @magic > ry do
        true -> ry
        false -> a / @magic
      end

    circle_list =
      cond do
        Integer.is_odd(a) && Integer.is_even(b) -> [ellipse(x, b * @zazz, rx, ry) | circle_list]
        Integer.is_even(a) && Integer.is_odd(b) -> [ellipse(x, b * @zazz, rx, ry) | circle_list]
        true -> circle_list
      end

    print_circles_grid(circle_list, a, b - 1, a1, b2)
  end
end
