# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # An appointment slot time with start and end.
      AppointmentSlotTime = Structure.new do
        # @return [String] The end timestamp of the appointment in UTC.
        attribute(:end_time, String, from: "endTime")

        # @return [String] The start timestamp of the appointment in UTC.
        attribute(:start_time, String, from: "startTime")
      end
    end
  end
end
