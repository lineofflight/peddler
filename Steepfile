# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature "sig"
  check "lib"

  library "delegate"
  library "forwardable"
  library "json"
  library "socket"
  library "time"
  library "uri"

  ignore "lib/generator"
  ignore "lib/generator.rb"
  ignore "lib/peddler/endpoint.rb"
  # Not much value in type-checking the generated Structure.new DSL, but provided they are correct, the corresponding
  # RBS declarations, also generated, ensure full type safety.
  ignore "lib/peddler/types"

  configure_code_diagnostics do |config|
    config[Steep::Diagnostic::Ruby::UnexpectedPositionalArgument] = :hint
  end
end
