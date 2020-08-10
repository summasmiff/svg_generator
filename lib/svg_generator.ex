defmodule SvgGenerator.CLI do
  require Logger
  import SvgGenerator.Utils
  import SvgGenerator.FunkyTruchet

  @moduledoc """
    compile && run: mix escript.build && ./svg_generator file_name
    https://www.w3.org/TR/SVG11
    https://github.com/joshnuss/xml_builder

    Generates SVGs for use with the AxiDraw drawing machine.
    Built for a standard 8.5" x 11" piece of paper (220mm x 280mm)
    All paths should be stroke: #000 and stroke-width: 1 for previewing
    The choice of pen actually determines stroke & color for final printing
  """

  def main(args) do
    svg = generate_svg()
    out_path = "./output/#{hd(args)}.svg"

    save_svg(%{svg: svg, out_path: out_path})
  end

  @doc """
   XMLBuilder takes a tuple where the first element is the name of the tag (as an atom),
   and the second element is the tag options.
   Tags can be nested by passing a list of tuples as the "opts" third element.
  """
  def generate_svg() do
    width = width()
    height = height()

    elements = elements()

    {:svg,
     %{
       viewBox: "0 0 #{width} #{height}",
       xmlns: "http://www.w3.org/2000/svg",
       width: "#{width}mm",
       height: "#{height}mm",
       "xml:space": "preserve"
     }, elements}
    |> XmlBuilder.generate()
  end

  def save_svg(%{svg: svg, out_path: out_path}) do
    case File.exists?(Path.expand(out_path)) do
      false ->
        File.mkdir(Path.dirname(out_path))

      true ->
        nil
    end

    Logger.debug("Saving svg to '#{out_path}'...")
    {:ok, file} = File.open(Path.expand(out_path), [:write])
    IO.binwrite(file, svg)
    File.close(file)
  end

  @doc """
    All files in art_scripts have a print() fn that takes no arguments
    Each returns a list of tuples that look like this:
    {:tag_name, options = %{fill: fill}, nested_tags // []}
  """
  def elements() do
    print()
  end
end
