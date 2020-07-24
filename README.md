# Generate SVGs using Elixir for use with the Axidraw plotter

compile && run: mix escript.build && ./svg_generator output_file_name

Generates SVGs for use with the AxiDraw pen plotter.
Designed for a standard 8.5" x 11" piece of paper (220mm x 280mm).
All paths should be stroke: #000 and stroke-width: 1 for previewing.
The choice of pen actually determines stroke & color for final printing.
To plot, use the [Axidraw extension](https://wiki.evilmadscientist.com/Axidraw_Software_Installation) for [Inkscape](https://inkscape.org/release/1.0/platforms/) to open the SVG.
