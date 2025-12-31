# -*- encoding: utf-8 -*-
# stub: graphql 2.5.16 ruby lib

Gem::Specification.new do |s|
  s.name = "graphql".freeze
  s.version = "2.5.16".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/rmosolgo/graphql-ruby/issues", "changelog_uri" => "https://github.com/rmosolgo/graphql-ruby/blob/master/CHANGELOG.md", "homepage_uri" => "https://graphql-ruby.org", "mailing_list_uri" => "https://buttondown.email/graphql-ruby", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/rmosolgo/graphql-ruby" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Robert Mosolgo".freeze]
  s.date = "2025-12-10"
  s.description = "A plain-Ruby implementation of GraphQL.".freeze
  s.email = ["rdmosolgo@gmail.com".freeze]
  s.homepage = "https://github.com/rmosolgo/graphql-ruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.6.2".freeze
  s.summary = "A GraphQL language and runtime for Ruby".freeze

  s.installed_by_version = "4.0.3".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<base64>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<fiber-storage>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<logger>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<benchmark-ips>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<concurrent-ruby>.freeze, ["~> 1.0".freeze])
  s.add_development_dependency(%q<google-protobuf>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<graphql-batch>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<memory_profiler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<minitest>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<minitest-focus>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<minitest-reporters>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<ostruct>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov-lcov>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<undercover>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<jekyll>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<jekyll-sass-converter>.freeze, ["~> 2.2".freeze])
  s.add_development_dependency(%q<yard>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<jekyll-algolia>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<jekyll-redirect-from>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<m>.freeze, ["~> 1.5.0".freeze])
  s.add_development_dependency(%q<mutex_m>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<webrick>.freeze, [">= 0".freeze])
end
