# frozen_string_literal: true

D = Steep::Diagnostic

target :lib do
  signature "sig"
  check "lib"

  library(
    "json",
    "open3",
    "rbs",
    "socket",
    "time",
    "uri",
  )

  configure_code_diagnostics(D::Ruby.strict)
end
