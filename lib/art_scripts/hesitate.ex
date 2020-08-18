defmodule SvgGenerator.Hesitate do
  require Logger
  require Integer
  import SvgGenerator.SVG

  @moduledoc """
    Copy of Bridget Riley piece: "Hesitate"
    https://www.tate.org.uk/art/artworks/riley-hesitate-t04132
    @magic and @zazz are semi-random ints that control the spacing and size of circles
    try playing with values between:
    @magic: 1-5 / affects circle radius
    @zazz: 10-20 / affects distance between circles
  """
  @magic 3
  @zazz 9

  @doc """
    to call: print(a, b, c)
    where "a" controls ellipses' x and rx
    and "b" controls ellipses' y and ry
    "c" is the row on the x axis that you want to be the "collapse" point
  """
  def print(a, b, c), do: print_hesitate([], a, b, c, a, b)

  @doc """
    escape / return
  """
  def print_hesitate(list, 0, 0, _c, _a1, _b2), do: list

  @doc """
    recursive grid drawing
    last y row
  """
  def print_hesitate(list, a, 0, c, a1, b2) do
    # percent = a / a1
    # x = (a*percent) * @zazz

    # ry = b2/@magic
    # rx = case a/@magic > ry do
    #   true -> ry
    #   false -> a/@magic
    # end

    # list = case Integer.is_odd(a) do
    #   false -> list
    #   _ -> [ellipse(x, 0, rx, ry) | list]
    # end
    print_hesitate(list, a - 1, b2, c, a1, b2)
  end

  @doc """
    last x row
  """
  def print_hesitate(list, 0, b, c, a1, b2) do
    ry = b2 / @magic

    list =
      case Integer.is_odd(b) do
        false -> list
        _ -> [ellipse(0, b * @zazz, 1, ry) | list]
      end

    print_hesitate(list, 0, b - 1, c, a1, b2)
  end

  @doc """
    bulk of recursive drawing
  """
  def print_hesitate(list, a, b, c, a1, b2) do
    diff = if a > c, do: a + 1 - c, else: c + 1 - a
    # how far from center is a

    # needs to be geometric sequence
    base = 0.92
    seq = a1 - a

    x = a * :math.pow(base, seq) * @zazz
    IO.inspect(x)
    y = b * @zazz

    ry = b2 / @magic

    rx =
      case diff / @magic > ry do
        true -> ry
        false -> diff / @magic * 1.75
      end

    list =
      cond do
        Integer.is_odd(a) && Integer.is_even(b) -> [ellipse(x, y, rx, ry) | list]
        Integer.is_even(a) && Integer.is_odd(b) -> [ellipse(x, y, rx, ry) | list]
        true -> list
      end

    print_hesitate(list, a, b - 1, c, a1, b2)
  end
end
