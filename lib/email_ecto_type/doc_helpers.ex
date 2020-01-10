defmodule EmailEctoType.DocHelpers do
  @moduledoc false

  @doc false
  def import_src!(%Macro.Env{file: base}, path) do
    base
    |> Path.dirname()
    |> Path.join(path)
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&("    " <> &1))
    |> Enum.join("\n")
  end
end
