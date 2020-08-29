# Generate SVGs using Elixir for use with the Axidraw plotter

Designed for a standard 8.5" x 11" piece of paper (220mm x 280mm).
All paths should be stroke: #000 and stroke-width: 1 for previewing.
The choice of pen actually determines stroke & color for final printing.
To plot, use the [Axidraw extension](https://wiki.evilmadscientist.com/Axidraw_Software_Installation) for [Inkscape](https://inkscape.org/release/1.0/platforms/) to open the SVG.

## Usage

svg generator is an Elixir escript, an executable that can be called from the command line.

To compile:

```
mix escript.build
```

To run:

```
./svg_generator output_file_name
```

## Modules

### SvgGenerator.SVG

Functions for creating SVG primitives to pass to XMLBuilder.

### SvgGenerator.Utils

Various geometric and graphic functions.

### Art Scripts

The scripts that actually produce the SVGs.
