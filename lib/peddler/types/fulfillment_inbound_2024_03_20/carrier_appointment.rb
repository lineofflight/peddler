# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains details for a transportation carrier appointment. This appointment is vended out by Amazon and is an
      # indicator for when a transportation carrier is accepting shipments to be picked up.
      CarrierAppointment = Structure.new do
        # @return [String] The end timestamp of the appointment in UTC.
        attribute(:end_time, String, from: "endTime")

        # @return [String] The start timestamp of the appointment in UTC.
        attribute(:start_time, String, from: "startTime")
      end
    end
  end
end
