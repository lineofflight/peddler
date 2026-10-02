# frozen_string_literal: true

require "fileutils"
require "json"
require "open3"
require "rbconfig"
require "timeout"

# `rake compile` and `rake native gem` leave a binary in lib/peddler. The loader
# prefers it over tmp/native, so the native tests would silently run it, possibly
# built for another Ruby.
def refuse_stale_binary!
  stale = Dir["lib/peddler/peddler_native.*", "lib/peddler/[0-9]*/peddler_native.*"]
  return if stale.empty?

  abort "#{stale.join(", ")} would shadow tmp/native. Remove it (rm #{stale.join(" ")}) and rerun."
end

# Runs a command in a child process and kills it at the deadline. Native code stuck holding the GVL can't be
# interrupted by a Ruby Timeout inside the test process, so the deadline has to live out here.
def run_with_deadline(seconds, label, *command)
  pid = Process.spawn(*command)
  begin
    _, status = Timeout.timeout(seconds) { Process.wait2(pid) }
    abort "#{label} failed" unless status.success?
  rescue Timeout::Error
    Process.kill("KILL", pid)
    Process.wait(pid)
    abort "#{label} exceeded #{seconds} seconds"
  end
end

namespace :native do
  desc "Build the local Rust extension into tmp/native"
  task :build do
    refuse_stale_binary!
    sh({ "RUBY" => RbConfig.ruby }, "cargo", "build", "-p", "peddler_native", "--locked")
    output, status = Open3.capture2("cargo", "metadata", "--format-version", "1", "--no-deps")
    abort "cargo metadata failed" unless status.success?

    target = JSON.parse(output).fetch("target_directory")
    suffix = RbConfig::CONFIG.fetch("host_os").include?("darwin") ? "dylib" : "so"
    FileUtils.mkdir_p("tmp/native")
    FileUtils.cp("#{target}/debug/libpeddler_native.#{suffix}", "tmp/native/peddler_native.#{RbConfig::CONFIG.fetch('DLEXT')}")
  end

  desc "Run native tests (requires native:build first)"
  task :test do
    refuse_stale_binary!
    run_with_deadline(60, "native tests", RbConfig.ruby, "-Ilib", "-Itmp/native", "test_native/run.rb")
  end
end
