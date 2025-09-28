# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rubocop/rake_task"
require "yard"

Minitest::TestTask.create do |t|
  t.libs << "test"
  t.test_globs = ["test/**/*_test.rb"]
end
RuboCop::RakeTask.new
YARD::Rake::YardocTask.new

desc "Run Steep type checking"
task :steep do
  sh "bundle exec steep check --severity-level=hint"
end

task default: [:rubocop, :test]
