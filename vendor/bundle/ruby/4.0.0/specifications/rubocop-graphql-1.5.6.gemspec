# -*- encoding: utf-8 -*-
# stub: rubocop-graphql 1.5.6 ruby lib

Gem::Specification.new do |s|
  s.name = "rubocop-graphql".freeze
  s.version = "1.5.6".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/DmitryTsepelev/rubocop-graphql/blob/master/CHANGELOG.md", "default_lint_roller_plugin" => "RuboCop::GraphQL::Plugin", "homepage_uri" => "https://github.com/DmitryTsepelev/rubocop-graphql", "source_code_uri" => "https://github.com/DmitryTsepelev/rubocop-graphql" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Dmitry Tsepelev".freeze]
  s.date = "2025-06-07"
  s.description = "A collection of RuboCop cops to improve GraphQL-related code".freeze
  s.email = ["dmitry.a.tsepelev@gmail.com".freeze]
  s.homepage = "https://github.com/DmitryTsepelev/rubocop-graphql".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0".freeze)
  s.rubygems_version = "3.6.2".freeze
  s.summary = "A collection of RuboCop cops to improve GraphQL-related code".freeze

  s.installed_by_version = "4.0.3".freeze

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, ["~> 2.0".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.9".freeze])
  s.add_runtime_dependency(%q<lint_roller>.freeze, ["~> 1.1".freeze])
  s.add_runtime_dependency(%q<rubocop>.freeze, [">= 1.72.1".freeze, "< 2".freeze])
end
