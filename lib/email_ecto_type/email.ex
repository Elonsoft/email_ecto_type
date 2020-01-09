defmodule EmailEctoType.Email do
  @moduledoc """
  Type representing an email address.
  """

  @enforce_keys [:address, :user, :host]
  defstruct [:address, :user, :host]

  @type t :: %__MODULE__{address: binary, user: binary, host: binary}

  def new(address_input, validators \\ [])

  def new(address_input, validators) when is_binary(address_input) do
    address = address_input |> String.trim() |> String.downcase()

    with {:ok, address} <- apply_validators(address, validators),
         {:ok, user, host} <- extract_info(address) do
      {:ok, %__MODULE__{address: address, user: user, host: host}}
    end
  end

  def new(_, _) do
    :error
  end

  defp apply_validators(address, validators) do
    Enum.reduce(validators, {:ok, address}, fn
      validator, {:ok, address} -> validator.validate(address)
      _, {:error, _} = error -> error
    end)
  end

  defp extract_info(address) do
    case String.split(address, "@") do
      [user, host] -> {:ok, user, host}
      _ -> {:error, :invalid_email_format}
    end
  end
end
