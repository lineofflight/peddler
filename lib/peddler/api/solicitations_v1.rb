# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Solicitations
    #
    # With the Solicitations API you can build applications that send non-critical solicitations to buyers. You can get
    # a list of solicitation types that are available for an order that you specify, then call an operation that sends a
    # solicitation to the buyer for that order. Buyers cannot respond to solicitations sent by this API, and these
    # solicitations do not appear in the Messaging section of Seller Central or in the recipient's Message Center. The
    # Solicitations API returns responses that are formed according to the <a
    # href=https://tools.ietf.org/html/draft-kelly-json-hal-08>JSON Hypertext Application Language</a> (HAL) standard.
    class SolicitationsV1 < API
      # Returns a list of solicitation types that are available for an order that you specify. A solicitation type is
      # represented by an actions object, which contains a path and query parameter(s). You can use the path and
      # parameter(s) to call an operation that sends a solicitation. Currently only the
      # productReviewAndSellerFeedbackSolicitation solicitation type is available.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which you want a list
      #   of available solicitation types.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @return [Hash] The API response
      def get_solicitation_actions_for_order(amazon_order_id, marketplace_ids)
        path = "/solicitations/v1/orders/#{amazon_order_id}"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).get(path, params:)
      end

      # Sends a solicitation to a buyer asking for seller feedback and a product review for the specified order. Send
      # only one productReviewAndSellerFeedback or free form proactive message per order.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a solicitation is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @return [Hash] The API response
      def create_product_review_and_seller_feedback_solicitation(amazon_order_id, marketplace_ids)
        path = "/solicitations/v1/orders/#{amazon_order_id}/solicitations/productReviewAndSellerFeedback"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, params:)
      end
    end
  end
end
