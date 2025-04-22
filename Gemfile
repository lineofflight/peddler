# frozen_string_literal: true

source "https://rubygems.org"

gemspec

group :development do
  gem "appraisal"
  gem "minitest"
  gem "rake"
  gem "rubocop"
  gem "rubocop-minitest"
  gem "rubocop-performance"
  gem "rubocop-rake"
  gem "rubocop-shopify"
  gem "vcr"
  gem "webmock"
  gem "yard"

  # TODO: Remove the version guard when Yard handles changes in the new Commonmarker
  # https://github.com/lsegal/yard/issues/1528
  gem "commonmarker", "~> 0.23.10"

  # TODO: Remove when deprecation warnings go away
  gem "fiddle"
  gem "rdoc"
end
