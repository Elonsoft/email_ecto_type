defmodule EmailEctoType.Support.Schema do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset

  embedded_schema do
    field :email, EmailEctoType
  end

  def changeset(%__MODULE__{} = schema, attrs) do
    Changeset.cast(schema, attrs, [:email])
  end
end
