# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "activesupport"
gem "appraisal"
gem "irb"
gem "minitest"
gem "rake"
gem "rbs"
gem "steep"
gem "vcr"
gem "webmock"
gem "yard"

group :lint do
  gem "herb", force_ruby_platform: true
  gem "rubocop"
  gem "rubocop-erb"
  gem "rubocop-minitest"
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-shopify"
end

# TODO: Remove the version guard when Yard handles changes in the new Commonmarker
# https://github.com/lsegal/yard/issues/1528
# Also update .github/dependabot.yml to remove the ignore rule when this is resolved
gem "commonmarker", "~> 0.23.10"

# TODO: Remove when deprecation warnings go away
gem "fiddle"
gem "rdoc"

# Removed from stdlib
# TODO: Remove when VCR updates to handle this natively
gem "cgi" if RUBY_VERSION >= "3.5"

# For exploratory code
gem "csv"
