# -*- encoding: utf-8 -*-
# stub: rubocop-on-rbs 1.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rubocop-on-rbs".freeze
  s.version = "1.8.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/ksss/rubocop-on-rbs", "default_lint_roller_plugin" => "RuboCop::RBS::Plugin", "homepage_uri" => "https://github.com/ksss/rubocop-on-rbs", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/ksss/rubocop-on-rbs" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["ksss".freeze]
  s.bindir = "exe".freeze
  s.date = "1980-01-02"
  s.description = "RuboCop extension for RBS file.".freeze
  s.email = ["co000ri@gmail.com".freeze]
  s.homepage = "https://github.com/ksss/rubocop-on-rbs".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2.0".freeze)
  s.rubygems_version = "3.7.0.dev".freeze
  s.summary = "RuboCop extension for RBS file.".freeze

  s.installed_by_version = "4.0.3".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<lint_roller>.freeze, ["~> 1.1".freeze])
  s.add_runtime_dependency(%q<rbs>.freeze, ["~> 3.5".freeze])
  s.add_runtime_dependency(%q<rubocop>.freeze, [">= 1.72.1".freeze, "< 2.0".freeze])
  s.add_runtime_dependency(%q<zlib>.freeze, [">= 0".freeze])
end
