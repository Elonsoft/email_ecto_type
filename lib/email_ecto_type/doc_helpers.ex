defmodule EmailEctoType.DocHelpers do
  @moduledoc false

  @doc false
  def import_src!(path) do
    path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&("    " <> &1))
    |> Enum.join("\n")
  end
end
