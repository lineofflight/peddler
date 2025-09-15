# frozen_string_literal: true

require "helper"
require "peddler/apis/supply_sources_2020_07_01"

module Peddler
  module APIs
    class SupplySources20200701Test < Minitest::Test
      include FeatureHelpers

      def test_get_supply_sources
        res = api.sandbox.get_supply_sources

        assert_predicate(res.status, :success?)
      end

      def test_create_supply_source
        res = api.sandbox.create_supply_source({})

        assert_predicate(res.status, :success?)
      end

      def test_get_supply_source
        res = api.sandbox.get_supply_source("cbc976e5-1e55-4d33-855b-35e6254f5a58")

        assert_predicate(res.status, :success?)
      end

      def test_update_supply_source
        res = api.sandbox.update_supply_source("test-id-123")

        assert_predicate(res.status, :success?)
      end

      def test_archive_supply_source
        res = api.sandbox.archive_supply_source("test-id-123")

        assert_predicate(res.status, :success?)
      end

      def test_update_supply_source_status
        res = api.sandbox.update_supply_source_status("test-id-123")

        assert_predicate(res.status, :success?)
      end
    end
  end
end
