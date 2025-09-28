# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature "sig"
  check "lib"

  ignore(
    "lib/peddler",
    # "lib/generator",
    # "lib/generator.rb",
  )

  library(
    "json",
    "socket",
    "time",
    "uri",
  )

  # configure_code_diagnostics do |config|
  #   config[Steep::Diagnostic::Ruby::UnexpectedPositionalArgument] = :hint
  # end
  #
end
