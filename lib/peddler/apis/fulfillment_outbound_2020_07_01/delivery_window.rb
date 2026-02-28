# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The time range within which a Scheduled Delivery fulfillment order should be delivered. This is only available
      # in the JP marketplace.
      DeliveryWindow = Structure.new do
        # @return [String] The date and time of the end of the Scheduled Delivery window. Must be in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute(:end_date, String, null: false, from: "endDate")

        # @return [String] The date and time of the start of the Scheduled Delivery window. Must be in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} format.
        attribute(:start_date, String, null: false, from: "startDate")
      end
    end
  end
end
