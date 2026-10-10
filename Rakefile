# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"
require "rbconfig"
require "rubocop/rake_task"
require "shellwords"
require "steep/rake_task"

# Bundler's release task tags, then pushes the source gem alone, and every user would compile Rust. A release is
# 4 platform gems, the source gem and the crate: see RELEASING.md.
Rake.application.tasks.select { |task| task.name.start_with?("release") }.each(&:clear)
desc "Refuse: a release is done by hand, see RELEASING.md"
task(:release) { abort("rake release would push the source gem alone. Follow RELEASING.md.") }

suite = Minitest::TestTask.create do |t|
  t.libs << "test" << "tmp/native"
  t.test_globs = ["test/**/*_test.rb", "test_native/**/*_test.rb"]
end
# The suite runs against the extension built into tmp/native, in a child process under a deadline
# (see run_with_deadline in rakelib/native.rake).
Rake::Task[:test].clear_actions.enhance(["native:build"]) do
  run_with_deadline(300, "tests", RbConfig.ruby, *Shellwords.split(suite.make_test_cmd))
end
RuboCop::RakeTask.new
Steep::RakeTask.new

# The generated Ruby carries its types inline, so the export follows it.
desc "Generate all code from specs"
task generate: "generate:rust" do
  require_relative "lib/generator"
  Generator.generate
  Rake::Task["rbs:export"].invoke
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

  desc "Pull latest Amazon specs, regenerate, and advance the pin"
  task :update do
    require_relative "lib/generator"
    Generator::Specs.advance!
    Rake::Task["generate"].invoke
  end

  # rust:verify compares the Rust generator's output with the files on disk, so it runs before generate
  # rewrites them. The git gate then covers both generators' paths and the signatures exported from them, so a
  # generator change that moves a type shows as drift.
  desc "Regenerate at the pinned spec revision; fail if committed output drifts"
  task verify: ["rust:verify", :generate] do
    require "open3"

    paths = Generator.generated_paths + RUST_GENERATED_PATHS + ["sig/inline"]
    status_out, _err, status = Open3.capture3("git", "status", "--porcelain", "--", *paths)
    raise "git status failed" unless status.success?

    if status_out.strip.empty?
      puts "Generated output matches committed code at pinned spec #{Generator::Specs.pinned_sha}."
    else
      diff_out, = Open3.capture2("git", "diff", "--", *paths)
      warn "Generated output drifted from committed code:"
      warn status_out
      warn diff_out
      abort "Generator verification failed: regeneration at the pinned spec changed " \
        "committed output. Commit the intended change or investigate the regression."
    end
  end
end

task default: [:rubocop, :test, :steep, "rbs:verify"]
