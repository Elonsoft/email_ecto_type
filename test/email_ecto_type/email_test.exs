defmodule EmailEctoType.EmailTest do
  @moduledoc false

  use ExUnit.Case
  use ExUnitProperties

  import EmailEctoType.StreamDataHelpers

  alias EmailEctoType.Email

  property "valid email is copied into address field" do
    check all email <- email_address() do
      assert {:ok, %Email{address: ^email}} = Email.new(email)
    end
  end

  property "user is everything before @ sign" do
    check all user <- non_empty_string(),
              host <- non_empty_string() do
      assert {:ok, %Email{user: ^user}} = Email.new("#{user}@#{host}")
    end
  end

  property "host is everything after @ sign" do
    check all user <- non_empty_string(),
              host <- non_empty_string() do
      assert {:ok, %Email{host: ^host}} = Email.new("#{user}@#{host}")
    end
  end

  property "trims an email" do
    check all email <- email_address(),
              whitespaced <- whitespace_string(email) do
      assert {:ok, %Email{address: ^email}} = Email.new(whitespaced)
    end
  end

  property "lowerizes an email" do
    check all email <- email_address(),
              camelized <- camelize_string(email) do
      assert {:ok, %Email{address: ^email}} = Email.new(camelized)
    end
  end
end
