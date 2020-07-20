defmodule SvgGenerator.Tessellation do
  @moduledoc """
    Inspired by MC Escher's "Circle Limit" tessellations
    https://www.d.umn.edu/~ddunham/dunisam07.pdf
    https://www.ics.uci.edu/~eppstein/junkyard/tiling.html
  """
  def replicate_motif(list), do: list

  def print() do
    replicate_motif([])
  end
end
