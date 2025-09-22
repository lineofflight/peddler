# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/supply_sources_2020_07_01/contact_details"
require "peddler/types/supply_sources_2020_07_01/throughput_config"
require "peddler/types/supply_sources_2020_07_01/operating_hours_by_day"
require "peddler/types/supply_sources_2020_07_01/duration"

module Peddler
  module Types
    module SupplySources20200701
      # The operational configuration of `supplySources`.
      OperationalConfiguration = Structure.new do
        # @return [ContactDetails]
        attribute(:contact_details, ContactDetails, from: "contactDetails")

        # @return [ThroughputConfig]
        attribute(:throughput_config, ThroughputConfig, from: "throughputConfig")

        # @return [OperatingHoursByDay]
        attribute(:operating_hours_by_day, OperatingHoursByDay, from: "operatingHoursByDay")

        # @return [Duration]
        attribute(:handling_time, Duration, from: "handlingTime")
      end
    end
  end
end
