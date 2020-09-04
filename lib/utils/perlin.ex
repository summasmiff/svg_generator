defmodule SvgGenerator.Perlin do
  import SvgGenerator.PermuntationMap
  import Bitwise
  import SvgGenerator.Utils
  @type x :: float()
  @type y :: float()
  @type point :: {x, y}
  # values 0 - 255 randomly sorted (uses map for speed of pattern match on indices)
  @perm permuntation_map()
  @moduledoc """
    2-dimensional implementation based on Ken Perlin's Improved Perlin Noise (2002)
  """

  @doc """
    should return a value between 0.0 and 1.0
    currently returns some huge ass integer
  """
  @spec perlin_2d(point) :: :float
  def perlin_2d({x, y} = point) do
    # Find integer coordinates smaller than our point in grid.
    # Potential trouble spot: all our points will be ints, so none of our distance vectors mean anything?
    x_1 = floor(x)
    y_1 = floor(y)

    # bitwise "and" to wrap our coordinates if they exceed 255
    x_1 = band(x_1, 255)
    y_1 = band(y_1, 255)

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
    dist_a = dist(a, point)
    dist_b = dist(b, point)
    dist_c = dist(c, point)
    dist_d = dist(d, point)

    # Calculate dot product of each distance vector and gradient vector
    # Skip this step?
    # a_prod = dot_product(dist_a, grad_a)
    # b_prod = dot_product(dist_b, grad_b)
    # c_prod = dot_product(dist_c, grad_c)
    # d_prod = dot_product(dist_d, grad_d)

    # Compute ease curves for relative x_1, y_1
    u = ease(x_1)
    v = ease(y_1)

    # Interpolate results
    lerp(
      lerp(grad_a, grad_c, u),
      lerp(grad_b, grad_d, u),
      v
    )
  end

  @doc """
    Eases coordinate values towards integral values. Makes final output smoother.
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
    might need to be reversed?
  """
  def dist({x1, y1}, {x, y}) do
    {x1 - x, y1 - y}
  end

  @doc """
    return a pseudorandom value for a given point
    converts the (x, y) coordinates into indices for @perm
    If we deal with a 2D noise, we will first do a lookup in the permutation table using x coord.
    This will return an integer value in the range [0:255].
    We will add the result of this lookup to y coord.
    Use the sum of these two numbers as an index of the permutation table again.
  """
  def grad({x, y}) do
    @perm[@perm[x] + y]
  end
end
