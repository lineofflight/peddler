# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class SupplySources20200701Test < Minitest::Test
      include FeatureHelpers

      def test_get_supply_sources
        res = api.get_supply_sources

        assert_success(res)
      end

      def test_create_supply_source
        res = api.create_supply_source({})

        assert_success(res)
      end

      def test_get_supply_source
        res = api.get_supply_source("cbc976e5-1e55-4d33-855b-35e6254f5a58")

        assert_success(res, typed: false)
      end

      def test_update_supply_source
        res = api.update_supply_source("test-id-123")

        assert_success(res)
      end

      def test_archive_supply_source
        res = api.archive_supply_source("test-id-123")

        assert_success(res)
      end

      def test_update_supply_source_status
        res = api.update_supply_source_status("test-id-123")

        assert_success(res)
      end
    end
  end
end
