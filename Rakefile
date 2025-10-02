# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "pathname"
require "rbs"
require "rbs/sorter"
require "rubocop/rake_task"
require "steep/rake_task"
require "yard"

require "generator/config"

Minitest::TestTask.create do |t|
  t.libs << "test"
  t.test_globs = ["test/**/*_test.rb"]
end
RuboCop::RakeTask.new
Steep::RakeTask.new
YARD::Rake::YardocTask.new

desc "Sort manually written RBS signature files"
task "rbs:sort" do
  manual_rbs_files = Dir.glob("sig/peddler/*.rbs")
  manual_rbs_files.each do |file|
    RBS::Sorter.new(Pathname(file)).run
  end
end

task default: [:rubocop, :test, :steep]
