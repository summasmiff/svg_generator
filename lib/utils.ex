defmodule SvgGenerator.Utils do
  require Logger
  @type x :: float()
  @type y :: float()
  @type point :: {x, y}
  @type points :: [point]

  @moduledoc """
    Various graphics utilities, including:
      - Trig operations
      - Controlled randomness
  """

  @doc """
    A4 paper size in mm
    if you don't feel like remembering
  """
  def height(), do: 220
  def width(), do: 280

  def a5_height(), do: 148
  def a5_width(), do: 210

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
  end

  @doc """
    points: list of {x, y} tuples
    returns points
  """
  def move_points(points, x_amount, y_amount) do
    Enum.map(points, fn point ->
      move_point(point, x_amount, y_amount)
    end)
  end

  defp move_point({x, y}, x_amount, y_amount) do
    new_x = x - x_amount
    new_y = y - y_amount
    {new_x, new_y}
  end

  @doc """
    scale points in place, maintaining center
    points: list of {x, y} tuples
    axis: [:x, :y, :both]
    returns points
  """
  @spec scale_points(points, :float, :atom) :: points
  def scale_points(points, amount, :x) do
    {{min_x, _min_y}, {max_x, _max_y}} = Enum.min_max_by(points, fn {x, _y} -> x end)
    center_x = (min_x + max_x) / 2

    Enum.map(points, fn point ->
      x_scale_point(point, center_x, amount)
    end)
  end

  def scale_points(points, amount, :y) do
    {{_min_x, min_y}, {_max_x, max_y}} = Enum.min_max_by(points, fn {_x, y} -> y end)
    center_y = (min_y + max_y) / 2

    Enum.map(points, fn point ->
      y_scale_point(point, center_y, amount)
    end)
  end

  defp x_scale_point({x, y}, center_x, x_amount) do
    distance = x - center_x
    scaled_distance = distance * x_amount
    new_x = center_x + scaled_distance
    {new_x, y}
  end

  defp y_scale_point({x, y}, center_y, y_amount) do
    distance = y - center_y
    scaled_distance = distance * y_amount
    new_y = center_y + scaled_distance
    {x, new_y}
  end

  @doc """
    Rotates a list of points around an origin.
    points: list of {x, y} tuples
    returns points
  """
  def rotate_points(points, degree, origin_x, origin_y) do
    Enum.map(points, fn point ->
      rotate_point(point, degree, origin_x, origin_y)
    end)
  end

  defp rotate_point({x, y}, degree, origin_x, origin_y) do
    radians = radians(degree)

    new_x = origin_x + (x - origin_x) * :math.cos(radians) - (y - origin_y) * :math.sin(radians)

    new_y = origin_y + (y - origin_y) * :math.cos(radians) + (x - origin_x) * :math.sin(radians)

    {new_x, new_y}
  end

  @doc """
    points: list of {x, y} tuples
    returns points
  """
  def shear_points(points, degree, axis) do
    Enum.map(points, fn {x, y} ->
      shear_point(x, y, degree, axis)
    end)
  end

  defp shear_point(x, y, degree, :x) do
    # m = hyperbolic cotangent of degree in radians
    radians = radians(degree)
    m = :math.atanh(radians)
    new_x = x + m * y
    {new_x, y}
  end

  defp shear_point(x, y, degree, :y) do
    radians = radians(degree)
    m = :math.atanh(radians)
    new_y = y + m * x
    {x, new_y}
  end

  @spec n_sided(:integer, point, :integer) :: points
  def n_sided(n, {x, y}, radius) when n > 2 do
    theta = 2 * :math.pi() / n
    angles = 0..(n - 1) |> Enum.map(&(&1 * theta))

    Enum.map(angles, fn angle ->
      {x + radius * :math.sin(angle), y + radius * :math.cos(angle)}
    end)
  end

  defdelegate noise_2d(point), to: SvgGenerator.Perlin
end
