# frozen_string_literal: true

require "fileutils"
require "json"
require "open3"
require "rbconfig"
require "timeout"

namespace :native do
  desc "Build the local Rust extension into tmp/native"
  task :build do
    sh({ "RUBY" => RbConfig.ruby }, "cargo", "build", "-p", "peddler-ruby", "--locked")
    output, status = Open3.capture2("cargo", "metadata", "--format-version", "1", "--no-deps")
    abort "cargo metadata failed" unless status.success?

    target = JSON.parse(output).fetch("target_directory")
    suffix = RbConfig::CONFIG.fetch("host_os").include?("darwin") ? "dylib" : "so"
    FileUtils.mkdir_p("tmp/native")
    FileUtils.cp("#{target}/debug/libpeddler_native.#{suffix}", "tmp/native/peddler_native.#{RbConfig::CONFIG.fetch('DLEXT')}")
  end

  desc "Run native tests (requires native:build first)"
  task :test do
    # A separate process deadline also catches a callback stuck holding the GVL.
    pid = Process.spawn(RbConfig.ruby, "-Ilib", "-Itmp/native", "test_native/client_test.rb")
    begin
      _, status = Timeout.timeout(60) { Process.wait2(pid) }
      abort "native tests failed" unless status.success?
    rescue Timeout::Error
      Process.kill("KILL", pid)
      Process.wait(pid)
      abort "native tests exceeded 60 seconds"
    end
  end
end
