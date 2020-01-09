# Used by "mix format"
[
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  import_deps: [:stream_data],
  line_length: 80,
  locals_without_parens: [
    # Ecto schema
    field: :*
  ]
]
