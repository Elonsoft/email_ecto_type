defmodule EmailEctoType.StreamDataHelpers do
  @moduledoc false

  import ExUnitProperties
  import StreamData

  @doc false
  @spec lift2(StreamData.t(a), StreamData.t(b), (a, b -> c)) :: StreamData.t(c)
        when a: term(), b: term(), c: term()
  def lift2(ga, gb, f) do
    bind(ga, fn a -> map(gb, &f.(a, &1)) end)
  end

  # Generators

  @doc false
  def email_address do
    gen all user <- non_empty_string(),
            host <- non_empty_string() do
      "#{user}@#{host}"
    end
  end

  @doc false
  def non_empty_string do
    string(?a..?z, min_length: 1)
  end

  @doc false
  def whitespace_string(str) do
    lift2(whitespaces(), whitespaces(), &(&1 <> str <> &2))
  end

  @doc false
  def whitespaces do
    gen all count <- integer(0..100) do
      " " |> constant |> Enum.take(count) |> Enum.into(<<>>)
    end
  end

  @doc false
  def camelize_string(str) do
    gen all positions <- list_of(integer(0..(String.length(str) - 1))) do
      Enum.reduce(positions, str, &capitalize_character_in_string(&2, &1))
    end
  end

  # Helper functions

  defp capitalize_character_in_string(str, position) when position >= 0 do
    if String.length(str) <= position do
      raise ArgumentError, """
      position must be less then the str length. Got #{position} for "#{str}"
      """
    end

    str_list = String.to_charlist(str)
    left = Enum.take(str_list, position)
    [char | right] = Enum.drop(str_list, position)
    to_string(left ++ [capitalize_character(char)] ++ right)
  end

  defp capitalize_character(char) when is_integer(char) do
    [capitalized] = String.to_charlist(String.capitalize(to_string([char])))
    capitalized
  end
end
