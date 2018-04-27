# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/test_*.rb'
  t.ruby_opts += ['-W1']
end

RuboCop::RakeTask.new

YARD::Rake::YardocTask.new do |t|
 # t.files   = ['lib/**/*.rb', OTHER_PATHS]   # optional
 # t.options = ['--any', '--extra', '--opts'] # optional
 # t.stats_options = ['--list-undoc']         # optional
end

task default: %i[test rubocop]
