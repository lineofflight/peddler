# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rubocop/rake_task"
require "steep/rake_task"
require "yard"

Minitest::TestTask.create do |t|
  t.libs << "test"
  t.test_globs = ["test/**/*_test.rb"]
end
RuboCop::RakeTask.new
Steep::RakeTask.new
YARD::Rake::YardocTask.new

task default: [:rubocop, :test]
