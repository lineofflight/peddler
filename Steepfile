# frozen_string_literal: true

target :lib do
  signature "sig"
  # Steep reads the annotations of the files checked inline. Their export is for applications.
  ignore_signature "sig/inline"

  # Hand-written Ruby and the generated operation methods carry their types as inline RBS, and `rake rbs:export`
  # writes sig/inline from these files.
  check "lib/peddler.rb", "lib/peddler/*.rb", "lib/peddler/lwa", "lib/peddler/native", inline: true
  # The typed models, against their generated RBS
  check "lib"

  ignore "lib/generator.rb"
  ignore "lib/generator"
  # It is written against WebMock, which has no signatures.
  ignore "lib/peddler/webmock.rb"
  ignore "lib/peddler/webmock.rb", inline: true

  library(
    "delegate",
    "json",
    "socket",
    "time",
    "uri",
  )
end
