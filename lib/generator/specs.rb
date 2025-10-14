# frozen_string_literal: true

require "open3"
require_relative "logger"
require_relative "config"

module Generator
  class Specs
    class << self
      def sync
        # Remove directory if it exists but is empty
        if Dir.exist?(directory) && Dir.empty?(directory)
          FileUtils.rm_rf(directory)
        end

        if !Dir.exist?(directory)
          clone!
        elsif older_than_one_day?
          Generator.logger.info("API models are over 1 day old, updating")
          update!
        else
          Generator.logger.info("Existing API models found")
        end
      end

      def directory
        File.join(Config::BASE_PATH, "selling-partner-api-models")
      end

      private

      def clone!
        Generator.logger.info("Cloning Amazon Selling Partner API models")
        repo_url = "https://github.com/amzn/selling-partner-api-models.git"
        _stdout, stderr, status = Open3.capture3("git", "clone", repo_url, directory)

        raise "Failed to clone API models: #{stderr}" unless status.success?
      end

      def update!
        _stdout, stderr, status = Open3.capture3("git", "-C", directory, "pull")

        raise "Failed to update API models: #{stderr}" unless status.success?
      end

      def older_than_one_day?
        git_dir = File.join(directory, ".git")
        return false unless Dir.exist?(git_dir)

        fetch_head = File.join(git_dir, "FETCH_HEAD")
        return true unless File.exist?(fetch_head)

        File.mtime(fetch_head) < Time.now - (24 * 60 * 60)
      end
    end
  end
end
