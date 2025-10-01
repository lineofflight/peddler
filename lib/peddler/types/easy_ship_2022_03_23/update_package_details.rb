# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/easy_ship_2022_03_23/time_slot"
require "peddler/types/easy_ship_2022_03_23/scheduled_package_id"

module Peddler
  module Types
    module EasyShip20220323
      # Request to update the time slot of a package.
      UpdatePackageDetails = Structure.new do
        # @return [TimeSlot]
        attribute(:package_time_slot, TimeSlot, from: "packageTimeSlot")

        # @return [ScheduledPackageId]
        attribute(:scheduled_package_id, ScheduledPackageId, from: "scheduledPackageId")
      end
    end
  end
end
