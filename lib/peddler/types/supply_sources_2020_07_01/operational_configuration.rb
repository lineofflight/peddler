# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/supply_sources_2020_07_01/contact_details"
require "peddler/types/supply_sources_2020_07_01/duration"
require "peddler/types/supply_sources_2020_07_01/operating_hours_by_day"
require "peddler/types/supply_sources_2020_07_01/throughput_config"

module Peddler
  module Types
    module SupplySources20200701
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
