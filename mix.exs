defmodule SvgGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :svg_generator,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:xml_builder, "~> 2.1.1"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp escript do
    [
      main_module: SvgGenerator.CLI
    ]
  end
end
