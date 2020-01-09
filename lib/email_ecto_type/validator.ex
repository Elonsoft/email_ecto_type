defmodule EmailEctoType.Validator do
  @moduledoc """
  Behaviour that any validator for EmailEctoType must follow.
  """

  @doc """
  Validates if an email satisfies the validator.
  """
  @callback validate(binary) :: {:ok, binary} | {:error, term}
end
