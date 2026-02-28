# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Time duration used to specify the interval of an event, such as pick up and delivery.
      TimeWindow = Structure.new do
        # @return [Integer] The end time of the window.
        attribute(:end_time, Integer, null: false, from: "endTime")

        # @return [Integer] The start time of the window.
        attribute(:start_time, Integer, null: false, from: "startTime")

        # @return [String] Whether the seller picks up from Amazon Logistics or drops off to Amazon Logistics.
        attribute?(:handover_method, String, from: "handoverMethod")
      end
    end
  end
end
