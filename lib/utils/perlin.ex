defmodule SvgGenerator.Perlin do
  import SvgGenerator.PermuntationMap
  import SvgGenerator.Utils
  alias Decimal, as: D
  @type x :: float()
  @type y :: float()
  @type point :: {x, y}
  # values 0 - 255 randomly sorted (uses map for speed of pattern match on indices)
  @perm permuntation_map()
  @moduledoc """
    2-dimensional implementation based on Ken Perlin's Improved Perlin Noise (2002)
  """

  @doc """
    for a given point, should return a consistent value between -1.0 and 1.0
    'should' being a key word
    if x, y are integers, value will be 0.0 (x and y should be floats with values to the hundreds place)
    try multiplying input values by powers of 2 to change octaves

    ## Examples
    iex> SvgGenerator.Perlin.noise_2d({10.25, 110.40})
    -1.1541468749999946

    iex> SvgGenerator.Perlin.noise_2d({140.03, 220.09})
    -0.8737968776348134
  """
  @spec noise_2d(point) :: :float
  def noise_2d({x, y} = point) do
    # Find integer coordinates smaller than our point in grid.
    # divide by one to turn an int into a float
    x_1 = floor(x) / 1
    y_1 = floor(y) / 1

    # wrap our coordinates if they exceed 255
    # should never exceed 512, so don't need to do more than subtract 255
    x_1 = if x_1 > 255.0, do: x_1 - 255.0, else: x_1
    y_1 = if y_1 > 255.0, do: y_1 - 255.0, else: y_1

    # Create square having 4 lattice points, one for each corner (a b c d)
    a = {x_1, y_1}
    b = {x_1 + 1, y_1}
    c = {x_1, y_1 + 1}
    d = {x_1 + 1, y_1 + 1}

    # Each corner has a randomly generated gradient vector created by our perm table and gradient function
    grad_a = grad(a)
    grad_b = grad(b)
    grad_c = grad(c)
    grad_d = grad(d)

    # Calculate "distance vector" from each lattice point to our point
    dist_a = dist(point, a)
    dist_b = dist(point, b)
    dist_c = dist(point, c)
    dist_d = dist(point, d)

    # Calculate dot product of each distance vector and gradient vector
    a_prod = dot_product(dist_a, grad_a)
    b_prod = dot_product(dist_b, grad_b)
    c_prod = dot_product(dist_c, grad_c)
    d_prod = dot_product(dist_d, grad_d)

    # Compute ease curves for relative x_1, y_1
    # Returning huge ass numbers?
    u = ease(x - x_1)
    v = ease(y - y_1)

    # Interpolate results
    lerp(
      lerp(a_prod, c_prod, u),
      lerp(b_prod, d_prod, u),
      v
    )
  end

  @doc """
    Eases coordinate values towards integral values. Makes final output smoother.

    ## Examples
    iex> SvgGenerator.Perlin.ease(0.25)
    0.103515625
  """
  @spec ease(:float) :: :float
  def ease(t) do
    # perlin ease 2.0
    ((6 * t - 15) * t + 10) * t * t * t

    # perlin ease 1.0
    # t * t * (3 - 2 * t)
  end

  def dot_product({a, b} = _distance_vector, {i, j} = _gradient_vector) do
    a * i + b * j
  end

  @doc """
    find distance between lattice point and original point

    ## Examples
    iex> SvgGenerator.Perlin.dist({0.5, 0.5}, {0.0, 0.0})
    {0.5, 0.5}

    iex> SvgGenerator.Perlin.dist({0.5, 0.5}, {1.0, 1.0})
    {-0.5, -0.5}

    iex> SvgGenerator.Perlin.dist({0.5, 0.5}, {1.0, 0.0})
    {-0.5, 0.5}

    iex> SvgGenerator.Perlin.dist({0.5, 0.5}, {0.0, 1.0})
    {0.5, -0.5}
  """
  def dist({x, y}, {x1, y1}) do
    dist_x = D.sub(D.from_float(x), D.from_float(x1)) |> D.to_float()
    dist_y = D.sub(D.from_float(y), D.from_float(y1)) |> D.to_float()
    {dist_x, dist_y}
  end

  @doc """
    return a pseudorandom gradient vector for a given point.
    converts the (x, y) coordinates into indices for our @perm map.
    This will return an integer value in the range [0:255].
    returns one of:
    {1, 1}
    {-1, 1}
    {1, -1}
    {-1, -1}

    ## Examples
    iex> SvgGenerator.Perlin.grad({110, 140})
    {1, -1}
  """
  def grad({x, y}) do
    # get a pseudorandom value from our table for our point
    value = @perm[@perm[round(x)] + round(y)]

    case rem(value, 4) do
      3 -> {-1, -1}
      2 -> {1, -1}
      1 -> {-1, 1}
      0 -> {1, 1}
    end
  end
end
