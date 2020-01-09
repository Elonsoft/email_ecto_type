defmodule EmailEctoType.FormatValidator do
  @moduledoc """
  Validates an email address against a simple regexp. Used as default
  validator for `EmailEctoType`.

  See `EmailEctoType.Validator` for details.
  """

  alias EmailEctoType.Validator

  @behaviour Validator

  @doc false
  @impl true
  def validate(address) when is_binary(address) do
    if Regex.match?(regexp(), address) and valid_length?(address) do
      {:ok, address}
    else
      {:error, :invalid_email_format}
    end
  end

  defp valid_length?(address) do
    byte_size(address) < 254
  end

  defp regexp do
    ~r/^[A-Za-z0-9\._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/
  end
end
