# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module EasyShip20220323
      # A time window to hand over an Easy Ship package to Amazon Logistics.
      TimeSlot = Structure.new do
        # @return [String] An Amazon-defined identifier for a time slot.
        attribute(:slot_id, String, from: "slotId")

        # @return [String] The start date and time of the time slot.
        attribute(:start_time, String, from: "startTime")

        # @return [String] The end date and time of the time slot.
        attribute(:end_time, String, from: "endTime")

        # @return [String] The method by which a seller will hand a package over to Amazon Logistics.
        attribute(:handover_method, String, from: "handoverMethod")
      end
    end
  end
end
