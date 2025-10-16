# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "pathname"
require "rbs"
require "rbs/sorter"
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

desc "Sort manually written RBS signature files"
task "rbs:sort" do
  manual_rbs_files = Dir.glob("sig/peddler/*.rbs")
  manual_rbs_files.each do |file|
    RBS::Sorter.new(Pathname(file)).run
  end
end

desc "Generate all code from specs"
task :generate do
  require_relative "lib/generator"
  Generator.generate
end

namespace :generate do
  desc "Setup generator and sync specs"
  task :setup do
    require_relative "lib/generator"
    Generator.setup
  end

  desc "Generate API classes"
  task apis: :setup do
    Generator.generate_apis
  end

  desc "Generate notification types"
  task notifications: :setup do
    Generator.generate_notifications
  end

  desc "Generate report types"
  task reports: :setup do
    Generator.generate_reports
  end

  desc "Generate feed types"
  task feeds: :setup do
    Generator.generate_feeds
  end

  desc "Generate Data Kiosk types"
  task data_kiosk: :setup do
    Generator.generate_data_kiosk
  end

  desc "Generate entrypoints"
  task entrypoints: :setup do
    Generator.generate_entrypoints
  end
end

task default: [:rubocop, :test, :steep]
