# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class CustomerFeedback20240601Test < Minitest::Test
      include FeatureHelpers

      def test_get_item_review_topics
        res = api.get_item_review_topics(asin: "B08PD3JNPF", marketplace_id: "ATVPDKIKX0DER", sort_by: "MENTIONS")

        assert_success(res)
      end

      def test_get_item_browse_node
        res = api.get_item_browse_node(asin: "B08PD3JNPF", marketplace_id: "ATVPDKIKX0DER")

        assert_success(res)
      end

      def test_get_browse_node_review_topics
        res = api.get_browse_node_review_topics(browse_node_id: "123456789", marketplace_id: "ATVPDKIKX0DER", sort_by: "STAR_RATING_IMPACT")

        assert_success(res)
      end

      def test_get_item_review_trends
        res = api.get_item_review_trends(asin: "B08PD3JNPF", marketplace_id: "ATVPDKIKX0DER")

        assert_success(res)
      end

      def test_get_browse_node_review_trends
        res = api.get_browse_node_review_trends(browse_node_id: "123456789", marketplace_id: "ATVPDKIKX0DER")

        assert_success(res)
      end

      def test_get_browse_node_return_topics
        res = api.get_browse_node_return_topics(browse_node_id: "123456789", marketplace_id: "ATVPDKIKX0DER")

        assert_success(res)
      end

      def test_get_browse_node_return_trends
        res = api.get_browse_node_return_trends(browse_node_id: "123456789", marketplace_id: "ATVPDKIKX0DER")

        assert_success(res)
      end
    end
  end
end
