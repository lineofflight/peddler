# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature "sig"
  check "lib"

  ignore(
    "lib/generator",
    "lib/generator.rb",
  )

  library(
    "json",
    "socket",
    "time",
    "uri",
  )
end
