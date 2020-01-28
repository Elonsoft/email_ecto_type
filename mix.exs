defmodule EmailEctoType.MixProject do
  use Mix.Project

  @version "0.1.4"

  def project do
    [
      app: :email_ecto_type,
      version: @version,
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "EmailEctoType",
      docs: docs(),

      # Hex
      description: description(),
      package: package()
    ]
  end

  def application, do: []

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 3.0"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:jason, "~> 1.0", optional: true},
      {:stream_data, "~> 0.4", only: [:test, :dev]}
    ]
  end

  defp docs do
    [
      main: "EmailEctoType",
      extras: ["README.md"],
      source_url: "https://github.com/Elonsoft/email_ecto_type"
    ]
  end

  defp description do
    """
    An ecto type that provides easy way of managing email addresses
    in a database
    """
  end

  defp package do
    [
      links: %{"GitHub" => "https://github.com/Elonsoft/email_ecto_type"},
      licenses: ["MIT"],
      files: ~w(.formatter.exs mix.exs README.md LICENSE.md lib test/support)
    ]
  end
end
