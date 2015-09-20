defmodule DocPlug.Mixfile do
  use Mix.Project

  def project do
    [app: :doc_plug,
     version: "1.0.0",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     deps: deps,
     package: package,
     docs: docs]
  end

  def application do
    [applications: [:plug],
     mod: {DocPlug, []}]
  end

  # External dependencies for the project.
  defp deps do
    [{:plug, "~> 1.0"},
     {:earmark, "~> 0.1", only: :dev},
     {:ex_doc, "~> 0.9", only: :dev}]
  end

  # Define package configuration.
  defp package do
    [files: ["lib", "mix.exs", "README.md", "CHANGELOG.md", "LICENSE.md"],
     contributors: ["Daniel Hill (hild)"],
     licenses: ["MIT"]]
  end

  # Documentation configuration.
  defp docs do
    [main: "README",
     extras: ["README.md", "CHANGELOG.md", "LICENSE.md"],
     source_ref: "1.0.0"]
  end
end
