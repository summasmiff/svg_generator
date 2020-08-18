defmodule SvgGenerator.Utils do
  require Logger

  @moduledoc """
    Various graphics utilities, including:
      - Trig operations
      - Controlled randomness
  """

  @doc """
    A1 paper size in mm
    if you don't feel like remembering
  """
  def height(), do: 220
  def width(), do: 280

  @doc """
    Changes degrees into radians.
    1 radian = the length of the arc of the circle
    equals the length of the radius of that circle.
  """
  def radians(degrees), do: :math.pi() * degrees / 180.0

  @doc """
    random noise
    returns value between 0.0 and 1.0
  """
  def noise() do
    :rand.uniform(10) * 0.1
  end

  def custom_noise(seed) do
    # count = seed / 12 |> Float.round()
    count = 3
    sin = :math.sin(seed)
    :math.pow(sin, count)
  end

  @doc """
    linear interpolation
    n1
    n2
    t interpolant: number between 0.0 and 1.0 (aka noise())
  """
  def lerp(n1, n2, t) do
    {low, high} = Enum.min_max([n1, n2])

    low * (1 - t) + high * t
    # or...?
    # (high - low) * t + low
  end
end
