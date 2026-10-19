# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module EasyShip20220323
      # A time window to hand over an Easy Ship package to Amazon Logistics.
      TimeSlot = Structure.new do
        # An Amazon-defined identifier for a time slot.
        attribute(:slot_id, String, null: false, from: "slotId")

        # The end date and time of the time slot.
        attribute?(:end_time, String, from: "endTime")

        # The method by which a seller will hand a package over to Amazon Logistics. Known values: `PICKUP`, `DROPOFF`.
        attribute?(:handover_method, String, from: "handoverMethod")

        # The start date and time of the time slot.
        attribute?(:start_time, String, from: "startTime")
      end
    end
  end
end
