# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The operational configuration of `supplySources`.
      OperationalConfiguration = Structure.new do
        # @return [ContactDetails]
        attribute?(:contact_details, ContactDetails, from: "contactDetails")

        # @return [Duration]
        attribute?(:handling_time, Duration, from: "handlingTime")

        # @return [OperatingHoursByDay]
        attribute?(:operating_hours_by_day, OperatingHoursByDay, from: "operatingHoursByDay")

        # @return [ThroughputConfig]
        attribute?(:throughput_config, ThroughputConfig, from: "throughputConfig")
      end
    end
  end
end
