# frozen_string_literal: true

# Ruby files that carry inline RBS annotations are checked with `inline: true`, and `rake rbs:export` writes their
# signatures to sig/inline. The list is found here, so converting a file edits no shared file.
inline = Dir["lib/peddler.rb", "lib/peddler/*.rb", "lib/peddler/{lwa,native}/**/*.rb"].select do |path|
  File.read(path).match?(/^\s*#(:| @rbs\b)/)
end

target :lib do
  signature "sig"
  ignore_signature "sig/inline"

  check(*inline, inline: true)
  check "lib"

  ignore "lib/generator.rb"
  ignore "lib/generator"
  # It is written against WebMock, which has no signatures.
  ignore "lib/peddler/webmock.rb"

  library(
    "delegate",
    "json",
    "socket",
    "time",
    "uri",
  )
end
