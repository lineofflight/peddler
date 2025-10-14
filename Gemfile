# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "activesupport"
gem "irb"
gem "minitest"
gem "rake"
gem "rbs"
gem "rubocop"
gem "rubocop-minitest"
gem "rubocop-performance"
gem "rubocop-rake"
gem "rubocop-shopify"
gem "steep"
gem "vcr"
gem "webmock"
gem "yard"

gem "herb", "~> 0.7", ">= 0.7.4"

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
gem "parallel"

gem "rubocop-on-rbs", "~> 1.8", group: :development
