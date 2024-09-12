# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Messaging
    #
    # With the Messaging API you can build applications that send messages to buyers. You can get a list of message
    # types that are available for an order that you specify, then call an operation that sends a message to the buyer
    # for that order. The Messaging API returns responses that are formed according to the <a
    # href=https://tools.ietf.org/html/draft-kelly-json-hal-08>JSON Hypertext Application Language</a> (HAL) standard.
    class MessagingV1 < API
      # Returns a list of message types that are available for an order that you specify. A message type is represented
      # by an actions object, which contains a path and query parameter(s). You can use the path and parameter(s) to
      # call an operation that sends a message.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which you want a list
      #   of available message types.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @return [Hash] The API response
      def get_messaging_actions_for_order(amazon_order_id, marketplace_ids)
        path = "/messaging/v1/orders/#{amazon_order_id}"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).get(path, params:)
      end

      # Sends a message asking a buyer to provide or verify customization details such as name spelling, images,
      # initials, etc.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def confirm_customization_details(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/confirmCustomizationDetails"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, body:, params:)
      end

      # Sends a message to a buyer to arrange a delivery or to confirm contact information for making a delivery.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def create_confirm_delivery_details(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/confirmDeliveryDetails"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, body:, params:)
      end

      # Sends a critical message that contains documents that a seller is legally obligated to provide to the buyer.
      # This message should only be used to deliver documents that are required by law.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def create_legal_disclosure(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/legalDisclosure"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, body:, params:)
      end

      # Sends a non-critical message that asks a buyer to remove their negative feedback. This message should only be
      # sent after the seller has resolved the buyer's problem.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @return [Hash] The API response
      def create_negative_feedback_removal(amazon_order_id, marketplace_ids)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/negativeFeedbackRemoval"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, params:)
      end

      # Sends a message to ask a buyer an order-related question prior to shipping their order.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def create_confirm_order_details(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/confirmOrderDetails"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, body:, params:)
      end

      # Sends a message to contact a Home Service customer to arrange a service call or to gather information prior to a
      # service call.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def create_confirm_service_details(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/confirmServiceDetails"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, body:, params:)
      end

      # Sends a message to a buyer to provide details about an Amazon Motors order. This message can only be sent by
      # Amazon Motors sellers.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def create_amazon_motors(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/amazonMotors"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, body:, params:)
      end

      # Sends a message to a buyer to provide details about warranty information on a purchase in their order.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def create_warranty(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/warranty"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, body:, params:)
      end

      # Returns a response containing attributes related to an order. This includes buyer preferences.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @return [Hash] The API response
      def get_attributes(amazon_order_id, marketplace_ids)
        path = "/messaging/v1/orders/#{amazon_order_id}/attributes"
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).get(path, params:)
      end

      # Sends a message to a buyer to share a digital access key needed to utilize digital content in their order.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def create_digital_access_key(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/digitalAccessKey"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, body:, params:)
      end

      # Sends a critical message to a buyer that an unexpected problem was encountered affecting the completion of the
      # order.
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def create_unexpected_problem(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/unexpectedProblem"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        rate_limit(1.0).post(path, body:, params:)
      end

      # Sends a message providing the buyer an invoice
      #
      # @param [String] amazon_order_id An Amazon order identifier. This specifies the order for which a message is
      #   sent.
      # @param [Array<String>] marketplace_ids A marketplace identifier. This specifies the marketplace in which the
      #   order was placed. Only one marketplace can be specified.
      # @param [Hash] body
      # @return [Hash] The API response
      def send_invoice(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{amazon_order_id}/messages/invoice"
        body = body
        params = {
          "marketplaceIds" => marketplace_ids,
        }.compact

        post(path, body:, params:)
      end
    end
  end
end
