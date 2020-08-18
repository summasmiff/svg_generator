defmodule SvgGenerator.Fall do
  require Logger
  import SvgGenerator.SVG

  @moduledoc """
    Copy of Bridget Riley piece: "Fall"
    https://www.tate.org.uk/art/artworks/riley-fall-t00616
  """

  @doc """
    Returns path for line.
    See SvgGenerator.Utils for details about d's format.
    0, 0 is top-left corner of our paper.
    280, 0 is top-right.
    0, 220 is bottom-left.
    280, 220 is bottom-right.
  """
  def print_line(x) when rem(x, 5) == 0 do
    # all relative curve paths
    # only initial x coordinates need to be derived from arg value

    a = moveTo(x, 0)
    b = curveTo(0, 0, 20, 13, 20, 39, true)
    c = curveTo(0, 25, -45, 40, -45, 56, true)

    d = curveTo(0, 17, 45, 25, 45, 38, true)
    e = curveTo(0, 13, -45, 16, -45, 30, true)

    f = curveTo(0, 14, 17, 11, 17, 19, true)
    g = curveTo(0, 8, -45, 10, -45, 15, true)

    h = curveTo(0, 6, 45, 5, 45, 11, true)
    i = curveTo(0, 6, -45, 8, -45, 11, true)

    final = Enum.join([a, b, c, d, e, f, g, h, i], "")
    path(final)
  end

  def print_line(_), do: ""

  @doc """
    Fall is made of a field of identical copies of the same wavy line.
    The line is vertical and undulates with a tightening curve from top to bottom.
    Each copy of the line should be offset horizontally a small amount.
    The undulation combined with the small offset creates the moire pattern.
  """
  def print() do
    # Loop over all x values from negative pixels to larger than page dimensions ones
    # to make sure undulations fill entire svg area
    Enum.map(-25..325, fn x ->
      print_line(x)
    end)
  end
end
