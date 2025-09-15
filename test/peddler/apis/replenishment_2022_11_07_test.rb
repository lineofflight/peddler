# frozen_string_literal: true

require "helper"
require "peddler/apis/replenishment_2022_11_07"

module Peddler
  module APIs
    class Replenishment20221107Test < Minitest::Test
      include FeatureHelpers

      def test_get_selling_partner_metrics
        res = api.sandbox.get_selling_partner_metrics

        assert_predicate(res.status, :success?)
      end

      def test_list_offer_metrics
        res = api.sandbox.list_offer_metrics

        assert_predicate(res.status, :success?)
      end

      def test_list_offers
        res = api.sandbox.list_offers

        assert_predicate(res.status, :success?)
      end
    end
  end
end
