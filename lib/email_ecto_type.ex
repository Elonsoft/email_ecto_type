if Code.ensure_compiled?(Ecto.Type) do
  defmodule EmailEctoType do
    @moduledoc """
    An ecto type that provides easy way of managing email addresses
    in a database.

    ## Usage

    Suppose you define the following schema

    #{
      EmailEctoType.DocHelpers.import_src!(__ENV__, "../test/support/schema.ex")
    }

    Now you can validate an email like this:

        iex(1)> alias EmailEctoType.Support.Schema
        iex(2)> alias EmailEctoType.Email
        iex(3)> changeset = Schema.changeset(%Schema{}, %{email: "asdf@host.com"})
        iex(4)> changeset.valid?
        true
        iex(5)> Ecto.Changeset.apply_changes(changeset)
        %Schema{email: %Email{address: "asdf@host.com", user: "asdf", host: "host.com"}}

    In case you provide an invalid email it will return an error on casting:

        iex(1)> alias EmailEctoType.Support.Schema
        iex(2)> changeset = Schema.changeset(%Schema{}, %{email: "asdf@"})
        iex(3)> changeset.valid?
        false
        iex(4)> changeset.errors
        [email: {"is invalid", [type: EmailEctoType, validation: :cast]}]

    ### Custom type

    You can also define your custom email type using this module:

    #{
      EmailEctoType.DocHelpers.import_src!(
        __ENV__,
        "../test/support/custom_email_type.ex"
      )
    }

    And use it in schema:

    #{
      EmailEctoType.DocHelpers.import_src!(
        __ENV__,
        "../test/support/schema_with_custom_type.ex"
      )
    }

    As we did not specify any validators for an email, it won't fail on invalid
    strings (see `EmailEctoType.Validator` for more info):

        iex(1)> alias EmailEctoType.Support.SchemaWithCustomType, as: Schema
        iex(2)> changeset = Schema.changeset(%Schema{}, %{email: "asdf@"})
        iex(3)> changeset.valid?
        true
    """

    # Note: It's a hack to bypass warnings from different versions
    # of Ecto.
    if macro_exported?(Ecto.Type, :__using__, 1) do
      use Ecto.Type

      @impl Ecto.Type
      def embed_as(_), do: :self
    else
      @behaviour Ecto.Type
    end

    alias EmailEctoType.{Email, FormatValidator}

    @impl Ecto.Type
    def type, do: :string

    @impl Ecto.Type
    def cast(address, validators \\ [FormatValidator])

    def cast(address, validators)
        when is_binary(address) do
      case Email.new(address, validators) do
        {:ok, email} -> {:ok, email}
        _ -> :error
      end
    end

    def cast(%Email{} = email, _) do
      {:ok, email}
    end

    @impl Ecto.Type
    def load(address) when is_binary(address) do
      case Email.new(address) do
        {:ok, email} -> {:ok, email}
        _ -> :error
      end
    end

    @impl Ecto.Type
    def dump(%Email{address: address}) do
      {:ok, address}
    end

    @impl Ecto.Type
    def equal?(email1, email2) do
      # Note: We don't use default parameters here to disable documentation
      # generation for Ecto.Type overridable callbacks.
      equal?(email1, email2, [FormatValidator])
    end

    @doc false
    def equal?(email1, email2, validators)

    def equal?(%Email{address: address}, %Email{address: address}, _) do
      true
    end

    def equal?(str1, str2, validators) when is_list(validators) do
      with {:ok, email1} <- to_email(str1, validators),
           {:ok, email2} <- to_email(str2, validators) do
        equal?(email1, email2)
      else
        _ -> false
      end
    end

    defp to_email(%Email{} = email, _) do
      {:ok, email}
    end

    defp to_email(address, validators) when is_list(validators) do
      Email.new(address, validators)
    end

    defmacro __using__(opts) do
      quote do
        @validators unquote(opts)[:validators] || []

        if macro_exported?(Ecto.Type, :__using__, 1) do
          use Ecto.Type

          @impl Ecto.Type
          defdelegate embed_as(x), to: EmailEctoType
        else
          @behaviour Ecto.Type
        end

        @impl Ecto.Type
        defdelegate type, to: EmailEctoType

        @impl Ecto.Type
        def cast(address) do
          EmailEctoType.cast(address, @validators)
        end

        @impl Ecto.Type
        defdelegate load(address), to: EmailEctoType

        @impl Ecto.Type
        defdelegate dump(address), to: EmailEctoType

        @impl Ecto.Type
        def equal?(address1, address2) do
          EmailEctoType.equal?(address1, address2, @validators)
        end
      end
    end
  end
end
