defimpl String.Chars, for: EmailEctoType.Email do
  def to_string(%EmailEctoType.Email{address: address}) do
    address
  end
end
