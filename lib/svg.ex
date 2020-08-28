defmodule SvgGenerator.SVG do
  @moduledoc """
    Functions for creating SVG primitives to pass to XMLBuilder
    https://www.w3.org/TR/SVG11
  """
  @doc """
    cx: x coordinate of center
    cy: y coordinate of center
    r: radius
  """
  def circle(cx, cy, r, opts \\ []) do
    {:circle, %{cx: cx, cy: cy, r: r, stroke: "#000", fill: "none"}, opts}
  end

  @doc """
    cx: x coordinate of center
    cy: y coordinate of center
    rx: horizontal radius
    ry: vertical radius
  """
  def ellipse(cx, cy, rx, ry, opts \\ []) do
    {:ellipse, %{cx: cx, cy: cy, rx: rx, ry: ry, stroke: "#000", fill: "none"}, opts}
  end

  def line(start_x, start_y, end_x, end_y, opts \\ []) do
    {:line, %{x1: start_x, y1: start_y, x2: end_x, y2: end_y, stroke: "#000", fill: "none"}, opts}
  end

  def rect(x, y, width, height, opts \\ []) do
    {:rect, %{x: x, y: y, width: width, height: height, stroke: "#000", fill: "none"}, opts}
  end

  @doc """
    points: string of paired x y coordinates
    coordinate pairs are separated by a single space
    individual coordinates are separated by a comma and no spaces
    ex: "850,75  958,137.5 958,262.5 850,325 742,262.6 742,137.5"
  """
  def polygon(points, opts \\ [])

  def polygon(points, opts) when is_list(points) do
    string_points = Enum.map(points, fn {x, y} -> "#{x},#{y}" end) |> Enum.join(" ")
    {:polygon, %{points: string_points, stroke: "#000", fill: "none"}, opts}
  end

  def polygon(points, opts) when is_binary(points) do
    {:polygon, %{points: points, stroke: "#000", fill: "none"}, opts}
  end

  @doc """
    Paths are the bread and butter of SVGs.
    https://www.w3.org/TR/SVG11/paths.html#PathData
    The main param for a path is "d", which contains instructions for tracing a path from beginning to end
    "d" can have the following letter options:
    M: moveto (absolute) takes 2 params: x y,
    m: moveto (relative) takes 2 params: x y,
    L: lineto (absolute) takes 2 params: x y,
    l: lineto (relative) takes 2 params: x y,
    C: curve (cubic bezier) takes 6 params:
      x1 y1, x2 y2, x y where 1 is the top handle and 2 is the bottom handle
    Q: curve (quadratic bezier), takes 4 params: x1 y1, x y, 1 is the handle
    S: curve (shorthand curve),
      takes 4 params: x2 y2, x y where 2 is the bottom handle.
      S must follow C as the top handle is a reflection of C's bottom handle
    z: close path

    Equilateral triangle path example:
    d = "M 100 100 L 300 100 L 200 300 z"
  """
  def path(d, opts \\ [])

  def path(d, opts) when is_list(d) do
    [start | rest] = d
    string_d = Enum.map(rest, &lineTo(&1)) |> Enum.join(" ")
    path(moveTo(start) <> string_d, opts)
  end

  def path(d, opts) do
    {:path, %{d: d, stroke: "#000", fill: "none"}, opts}
  end

  @doc """
    functions for creating the "d" string for a path
    "d" should always be a string comprised of operations separated by commas
    (commas not required but makes it easier to debug)
  """
  def moveTo(x, y) when is_number(x) and is_number(y), do: moveTo({x, y})

  def moveTo({x, y}) do
    "M #{x}, #{y}"
  end

  def lineTo(x, y) when is_number(x) and is_number(y), do: lineTo({x, y})

  def lineTo({x, y}) do
    "L #{x}, #{y}"
  end

  @doc """
   rx ry x-axis-rotation large-arc-flag sweep-flag x y
   large_arc_flag: determines if arc should be > 180 deg (>180 : 1, < 180: 0)
   sweep_flag: determines if arc should start with neg or pos degrees (pos: 1, neg: 0)
   default to "0, 1" for these values if unsure
  """
  def arc(rx, ry, x_rot, large_arc_flag, sweep_flag, x, y, rel \\ false) do
    path = "#{rx}, #{ry}, #{x_rot}, #{large_arc_flag}, #{sweep_flag}, #{x}, #{y}"
    if rel, do: "a" <> path, else: "A" <> path
  end

  @doc """
    rel: path is relative to previous path
  """
  def curveTo(x, y, hand1_x, hand1_y, hand2_x, hand2_y, rel \\ false) do
    path = "#{x}, #{y}, #{hand1_x}, #{hand1_y}, #{hand2_x}, #{hand2_y}"
    if rel, do: "c" <> path, else: "C" <> path
  end
end
