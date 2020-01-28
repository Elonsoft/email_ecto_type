defmodule EmailEctoTypeTest do
  @moduledoc false

  use ExUnit.Case
  doctest EmailEctoType

  alias Ecto.Changeset
  alias EmailEctoType.Email

  describe "Ecto.Changeset.cast/3" do
    setup do
      assert {:ok, email} = Email.new("asdf@example.com")
      [schema: {%{email: email}, %{email: EmailEctoType}}, email: email]
    end

    @tag timeout: 5_000
    test "casts new value as string", %{schema: {_, types}} do
      attrs = %{"email" => "asdf1@example.com"}
      assert changeset = Changeset.cast({%{}, types}, attrs, [:email])
      assert %Changeset{valid?: true, changes: %{email: email}} = changeset
      assert %Email{address: "asdf1@example.com"} = email
    end

    @tag timeout: 5_000
    test "casts new value as email struct", %{schema: {_, types}} do
      {:ok, email} = Email.new("asdf1@example.com")
      attrs = %{"email" => email}
      assert changeset = Changeset.cast({%{}, types}, attrs, [:email])
      assert %Changeset{valid?: true, changes: %{email: email}} = changeset
      assert %Email{address: "asdf1@example.com"} = email
    end

    @tag timeout: 5_000
    test "casts updated value as string", %{schema: schema} do
      attrs = %{"email" => "asdf1@example.com"}
      assert changeset = Changeset.cast(schema, attrs, [:email])
      assert %Changeset{valid?: true, changes: %{email: email}} = changeset
      assert %Email{address: "asdf1@example.com"} = email
    end

    @tag timeout: 5_000
    test "casts updated value as email struct", %{schema: schema} do
      {:ok, email} = Email.new("asdf1@example.com")
      attrs = %{"email" => email}
      assert changeset = Changeset.cast(schema, attrs, [:email])
      assert %Changeset{valid?: true, changes: %{email: email}} = changeset
      assert %Email{address: "asdf1@example.com"} = email
    end
  end
end
