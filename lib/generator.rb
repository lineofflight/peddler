# frozen_string_literal: true

require "generator/specs"
require "generator/api"
require "generator/notification"
require "generator/report"
require "generator/feed"
require "generator/entrypoint"
require "generator/support/introspection_loader"

# @!visibility private
module Generator
  class << self
    def generate
      # Setup introspection loader once before any parallel operations
      # This allows forked processes to inherit the loader without creating new ones
      IntrospectionLoader.setup

      sync_specs
      generate_apis
      generate_notifications
      generate_reports
      generate_feeds
      generate_entrypoints
    end

    def sync_specs
      Specs.sync
    end

    def generate_apis
      API.generate
    end

    def generate_notifications
      Notification.generate
    end

    def generate_reports
      Report.generate
    end

    def generate_feeds
      Feed.generate
    end

    def generate_entrypoints
      Entrypoint.generate
    end
  end
end
