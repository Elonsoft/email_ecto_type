defmodule EmailEctoType.Support.SchemaWithCustomType do
  @moduledoc false

  use Ecto.Schema

  alias Ecto.Changeset
  alias EmailEctoType.Support.CustomEmailType

  embedded_schema do
    field :email, CustomEmailType
  end

  def changeset(%__MODULE__{} = schema, attrs) do
    Changeset.cast(schema, attrs, [:email])
  end
end
