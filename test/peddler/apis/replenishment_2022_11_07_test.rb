# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class Replenishment20221107Test < Minitest::Test
      include FeatureHelpers

      def test_get_selling_partner_metrics
        res = api.get_selling_partner_metrics

        assert_success(res)
      end

      def test_list_offer_metrics
        res = api.list_offer_metrics

        assert_success(res)
      end

      def test_list_offers
        res = api.list_offers

        assert_success(res)
      end
    end
  end
end
