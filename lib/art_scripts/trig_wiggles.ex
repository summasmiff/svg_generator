defmodule SvgGenerator.TrigWiggles do
  require Logger
  require Float
  import SvgGenerator.Utils
  @moduledoc """
    Exercise from "Generative Art" by Matt Pearson
  """
  def print_circle(line, _centerX, _centerY, _radius, 3240), do: line
  def print_circle([], centerX, centerY, radius, angle) do
    rad = radians(angle)
    x = centerX + (radius * :math.cos(rad)) |> Float.round(3)
    y = centerY + (radius * :math.sin(rad)) |> Float.round(3)

    print_circle([moveTo(x,y)], centerX, centerY, radius, (angle + 5))
  end
  def print_circle(line, centerX, centerY, radius, angle) do
    rad = radians(angle)
    x = centerX + (radius * :math.cos(rad)) |> Float.round(3)
    y = centerY + (radius * :math.sin(rad)) |> Float.round(3)

    rand = noise()
    noisy_x = x + (custom_noise(rand) * 5)
    noisy_y = y + (custom_noise(rand) * 5)

    new_radius = radius + 0.15

    print_circle([line | [lineTo(noisy_x, noisy_y)]], centerX, centerY, new_radius, (angle + 5))
  end

  def print() do
    line = print_circle([], height()/2, width()/2, 1, 0)
    d = Enum.join([ moveTo(0,0) | line], " ")
    [ path(d) ]
  end
end
