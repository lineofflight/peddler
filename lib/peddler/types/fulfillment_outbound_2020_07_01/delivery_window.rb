# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The time range within which a Scheduled Delivery fulfillment order should be delivered. This is only available
      # in the JP marketplace.
      DeliveryWindow = Structure.new do
        # @return [String] The date and time of the start of the Scheduled Delivery window. Must be in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> format.
        attribute(:start_date, String, from: "startDate")

        # @return [String] The date and time of the end of the Scheduled Delivery window. Must be in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> format.
        attribute(:end_date, String, from: "endDate")
      end
    end
  end
end
