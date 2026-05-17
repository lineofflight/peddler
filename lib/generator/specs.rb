# frozen_string_literal: true

require "fileutils"
require "open3"
require_relative "support/logger"
require_relative "support/config"

module Generator
  # Manages the local checkout of Amazon's selling-partner-api-models repo.
  #
  # Generation is reproducible: `sync(ref:)` checks out an exact revision (the
  # pinned SHA for `generate`/`verify`). `advance!` is the only path that moves
  # the pin forward, used by `rake generate:update` / the nightly workflow.
  class Specs
    REPO_URL = "https://github.com/amzn/selling-partner-api-models.git"
    PIN_FILE = File.join(Config::BASE_PATH, "selling-partner-api-models.sha")

    class << self
      # Ensure the local clone exists and is checked out at +ref+.
      def sync(ref:)
        ensure_clone!
        fetch!
        checkout!(ref)
        Generator.logger.info("Synced API models to #{ref}")
      end

      # Pull the latest upstream default branch, point the pin at it, and
      # return the resolved SHA. Caller is responsible for regenerating.
      def advance!
        ensure_clone!
        fetch!
        checkout!("origin/HEAD")
        sha = resolve_head
        write_pin(sha)
        Generator.logger.info("Advanced API models pin to #{sha}")
        sha
      end

      def pinned_sha
        File.read(PIN_FILE).strip
      end

      def directory
        File.join(Config::BASE_PATH, "selling-partner-api-models")
      end

      private

      def ensure_clone!
        FileUtils.rm_rf(directory) if Dir.exist?(directory) && Dir.empty?(directory)
        return if Dir.exist?(directory)

        Generator.logger.info("Cloning Amazon Selling Partner API models")
        run!("git", "clone", "--quiet", REPO_URL, directory)
      end

      def fetch!
        run!("git", "-C", directory, "fetch", "--quiet", "origin")
      end

      def checkout!(ref)
        run!("git", "-C", directory, "-c", "advice.detachedHead=false", "checkout", "--quiet", ref)
      end

      def resolve_head
        stdout, stderr, status = Open3.capture3("git", "-C", directory, "rev-parse", "HEAD")
        raise "Failed to resolve API models HEAD: #{stderr}" unless status.success?

        stdout.strip
      end

      def run!(*argv)
        _stdout, stderr, status = Open3.capture3(*argv)
        raise "Command failed (#{argv.join(" ")}): #{stderr}" unless status.success?
      end

      # Atomic: write to a sibling temp file, then rename into place.
      def write_pin(sha)
        tmp = "#{PIN_FILE}.tmp"
        File.write(tmp, "#{sha}\n")
        File.rename(tmp, PIN_FILE)
      end
    end
  end
end
