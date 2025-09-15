# frozen_string_literal: true

require "peddler/api"

module Peddler
  class << self
    def messaging_v1(...)
      APIs::MessagingV1.new(...)
    end
  end

  module APIs
    # Selling Partner API for Messaging
    #
    # With the Messaging API you can build applications that send messages to buyers. You can get a list of message
    # types that are available for an order that you specify, then call an operation that sends a message to the buyer
    # for that order. The Messaging API returns responses that are formed according to the <a
    # href=https://tools.ietf.org/html/draft-kelly-json-hal-08>JSON Hypertext Application Language</a> (HAL) standard.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/messaging.json
    class MessagingV1 < API
      # Returns a list of message types that are available for an order that you specify. A message type is represented
      # by an actions object, which contains a path and query parameter(s). You can use the path and parameter(s) to
      # call an operation that sends a message.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This specifies the order for which you want a list
      #   of available message types.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_messaging_actions_for_order(amazon_order_id, marketplace_ids, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::GetMessagingActionsForOrderResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Sends a message asking a buyer to provide or verify customization details such as name spelling, images,
      # initials, etc.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def confirm_customization_details(amazon_order_id, marketplace_ids, body, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/confirmCustomizationDetails"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::CreateConfirmCustomizationDetailsResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Sends a message to a buyer to arrange a delivery or to confirm contact information for making a delivery.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_confirm_delivery_details(amazon_order_id, marketplace_ids, body, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/confirmDeliveryDetails"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::CreateConfirmDeliveryDetailsResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Sends a critical message that contains documents that a seller is legally obligated to provide to the buyer.
      # This message should only be used to deliver documents that are required by law.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_legal_disclosure(amazon_order_id, marketplace_ids, body, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/legalDisclosure"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::CreateLegalDisclosureResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Sends a message to ask a buyer an order-related question prior to shipping their order.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_confirm_order_details(amazon_order_id, marketplace_ids, body, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/confirmOrderDetails"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::CreateConfirmOrderDetailsResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Sends a message to contact a Home Service customer to arrange a service call or to gather information prior to a
      # service call.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_confirm_service_details(amazon_order_id, marketplace_ids, body, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/confirmServiceDetails"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::CreateConfirmServiceDetailsResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Sends a message to a buyer to provide details about an Amazon Motors order. This message can only be sent by
      # Amazon Motors sellers.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_amazon_motors(amazon_order_id, marketplace_ids, body, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/amazonMotors"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::CreateAmazonMotorsResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Sends a message to a buyer to provide details about warranty information on a purchase in their order.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_warranty(amazon_order_id, marketplace_ids, body, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/warranty"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::CreateWarrantyResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Returns a response containing attributes related to an order. This includes buyer preferences.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def get_attributes(amazon_order_id, marketplace_ids, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/attributes"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::GetAttributesResponse if typed?
        meter(rate_limit).get(path, params:, parser:)
      end

      # Sends a buyer a message to share a digital access key that is required to utilize digital content in their
      # order.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_digital_access_key(amazon_order_id, marketplace_ids, body, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/digitalAccessKey"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::CreateDigitalAccessKeyResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Sends a critical message to a buyer that an unexpected problem was encountered affecting the completion of the
      # order.
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @param rate_limit [Float] Requests per second
      # @return [Peddler::Response] The API response
      def create_unexpected_problem(amazon_order_id, marketplace_ids, body, rate_limit: 1.0)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/unexpectedProblem"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::CreateUnexpectedProblemResponse if typed?
        meter(rate_limit).post(path, body:, params:, parser:)
      end

      # Sends a message providing the buyer an invoice
      #
      # @note This operation can make a static sandbox call.
      # @param amazon_order_id [String] An Amazon order identifier. This identifies the order for which a message is
      #   sent.
      # @param marketplace_ids [Array<String>] A marketplace identifier. This identifies the marketplace in which the
      #   order was placed. You can only specify one marketplace.
      # @param body [Hash] This contains the message body for a message.
      # @return [Peddler::Response] The API response
      def send_invoice(amazon_order_id, marketplace_ids, body)
        path = "/messaging/v1/orders/#{percent_encode(amazon_order_id)}/messages/invoice"
        params = {
          "marketplaceIds" => stringify_array(marketplace_ids),
        }.compact
        parser = Peddler::Types::MessagingV1::InvoiceResponse if typed?
        post(path, body:, params:, parser:)
      end

      private

      def load_types
        require "peddler/types/messaging_v1"
      end
    end
  end
end
