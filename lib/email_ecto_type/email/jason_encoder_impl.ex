if Code.ensure_compiled?(Jason) do
  defimpl Jason.Encoder, for: EmailEctoType.Email do
    def encode(%EmailEctoType.Email{address: address}, _) do
      Jason.encode!(address)
    end
  end
end
