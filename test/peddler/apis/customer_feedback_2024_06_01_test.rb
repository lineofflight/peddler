# frozen_string_literal: true

require "helper"
require "peddler/apis/customer_feedback_2024_06_01"

module Peddler
  module APIs
    class CustomerFeedback20240601Test < Minitest::Test
      include FeatureHelpers

      def test_get_item_review_topics
        res = api.sandbox.get_item_review_topics("B08PD3JNPF", "ATVPDKIKX0DER", "MENTIONS")

        assert_predicate(res.status, :success?)
      end

      def test_get_item_browse_node
        res = api.sandbox.get_item_browse_node("B08PD3JNPF", "ATVPDKIKX0DER")

        assert_predicate(res.status, :success?)
      end

      def test_get_browse_node_review_topics
        res = api.sandbox.get_browse_node_review_topics("123456789", "ATVPDKIKX0DER", "STAR_RATING_IMPACT")

        assert_predicate(res.status, :success?)
      end

      def test_get_item_review_trends
        res = api.sandbox.get_item_review_trends("B08PD3JNPF", "ATVPDKIKX0DER")

        assert_predicate(res.status, :success?)
      end

      def test_get_browse_node_review_trends
        res = api.sandbox.get_browse_node_review_trends("123456789", "ATVPDKIKX0DER")

        assert_predicate(res.status, :success?)
      end

      def test_get_browse_node_return_topics
        res = api.sandbox.get_browse_node_return_topics("123456789", "ATVPDKIKX0DER")

        assert_predicate(res.status, :success?)
      end

      def test_get_browse_node_return_trends
        res = api.sandbox.get_browse_node_return_trends("123456789", "ATVPDKIKX0DER")

        assert_predicate(res.status, :success?)
      end
    end
  end
end
