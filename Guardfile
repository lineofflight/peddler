guard :minitest, all_on_start: false do
  watch(%r{^test/(.*)\/?test_(.*)\.rb})
  watch(%r{^lib/(.*/)?([^/]+)\.rb}) { |m| "test/unit/#{m[1]}test_#{m[2]}.rb" }
  watch(%r{^test/.*helper\.rb}) { 'test' }
end
