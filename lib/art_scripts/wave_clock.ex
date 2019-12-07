defmodule SvgGenerator.WaveClock do
  import SvgGenerator.Utils
  @moduledoc """
    Exercise from "Generative Art" by Matt Pearson
  """
  @centerX 140
  @centerY 110

  def print_line(acc, _radius, 0), do: acc
  def print_line(acc, radius, angle) do
    rad = radians(angle)
    x1 = @centerX + (radius * :math.cos(rad))
    y1 = @centerY + (radius * :math.sin(rad))

    opprad = rad + :math.pi()
    x2 = @centerX + (radius * :math.cos(opprad))
    y2 = @centerY + (radius * :math.sin(opprad))

    # add noise here
    new_radius = radius
    line = line(x1, y1, x2, y2)

    print_line([line | acc], new_radius, angle-7)
  end

  def print() do
    radius = 100
    print_line([], radius, 360)
  end
end
