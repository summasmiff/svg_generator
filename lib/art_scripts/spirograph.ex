defmodule SvgGenerator.Spirograph do
  import SvgGenerator.SVG
  import SvgGenerator.Utils

  @moduledoc """
    Produces hypotrochoids similar to those produced by
    the Spirograph drawing toy.
  """

  @doc """
    in hypotrochoids a smaller circle travels within a larger circle
    big_R is the radius of the outer circle
    little_r is the radius of the inner circle
    in epitrochoids (not implemented) the smaller circle travels around the outside of the outer circle
  """
  # needs to be >= little_r
  @big_R 37
  @little_r 7
  @offset 15

  def x(rad) do
    (@big_R + @little_r) * :math.cos(rad) -
      (@little_r + @offset) * :math.cos((@big_R + @little_r) / @little_r * rad)
  end

  def y(rad) do
    (@big_R + @little_r) * :math.sin(rad) -
      (@little_r + @offset) * :math.sin((@big_R + @little_r) / @little_r * rad)
  end

  def print_spiro(list, 0), do: list

  def print_spiro([], angle) do
    rad = radians(angle)
    x = x(rad) + width() / 2
    y = y(rad) + height() / 2

    print_spiro([moveTo(x, y)], angle - 1)
  end

  def print_spiro(list, angle) do
    rad = radians(angle)
    x = x(rad) + width() / 2
    y = y(rad) + height() / 2

    print_spiro([list | [lineTo(x, y)]], angle - 1)
  end

  def print() do
    angle = 360 * 10
    d = print_spiro([], angle)
    [path(d)]
  end
end
